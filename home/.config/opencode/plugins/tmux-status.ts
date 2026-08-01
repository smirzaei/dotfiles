import type { Plugin } from "@opencode-ai/plugin"

type Status = "idle" | "busy" | "waiting" | "error"

type EventProperties = {
  id?: string
  requestID?: string
  sessionID?: string
  status?: { type?: string }
  info?: { id?: string }
}

export const TmuxStatusPlugin: Plugin = async ({ $ }) => {
  const pane = process.env.TMUX_PANE
  if (!process.env.TMUX || !pane || !/^%\d+$/.test(pane)) return {}

  const busySessions = new Set<string>()
  const errorSessions = new Set<string>()
  const pendingRequests = new Map<string, string>()
  const unknownSessionID = ""
  let status: Status | undefined
  let updates = Promise.resolve()

  const publish = () => {
    const next: Status =
      errorSessions.size > 0
        ? "error"
        : pendingRequests.size > 0
          ? "waiting"
          : busySessions.size > 0
            ? "busy"
            : "idle"
    if (next === status) return updates

    status = next
    updates = updates
      .then(async () => {
        await $`tmux set-option -p -t ${pane} @opencode_status ${next}`.quiet()
      })
      .catch(() => {
        if (status === next) status = undefined
      })
    return updates
  }

  const clearRequests = (sessionID: string) => {
    for (const [requestID, waitingSessionID] of pendingRequests) {
      if (waitingSessionID === sessionID) pendingRequests.delete(requestID)
    }
  }

  const markIdle = (sessionID: string) => {
    busySessions.delete(sessionID)
    clearRequests(sessionID)
  }

  const clearSession = (sessionID: string) => {
    markIdle(sessionID)
    errorSessions.delete(sessionID)
  }

  await publish()

  return {
    "chat.message": async ({ sessionID }) => {
      errorSessions.delete(sessionID)
      errorSessions.delete(unknownSessionID)
      busySessions.add(sessionID)
      await publish()
    },
    event: async ({ event }) => {
      const type = event.type as string
      const properties = event.properties as EventProperties

      switch (type) {
        case "session.status": {
          const sessionID = properties.sessionID
          if (!sessionID) return

          if (properties.status?.type === "idle") markIdle(sessionID)
          if (properties.status?.type === "busy" || properties.status?.type === "retry") {
            errorSessions.delete(sessionID)
            errorSessions.delete(unknownSessionID)
            busySessions.add(sessionID)
          }
          break
        }
        case "session.idle": {
          if (properties.sessionID) markIdle(properties.sessionID)
          break
        }
        case "session.error": {
          const sessionID = properties.sessionID ?? unknownSessionID
          busySessions.delete(sessionID)
          errorSessions.add(sessionID)
          break
        }
        case "session.deleted": {
          const sessionID = properties.sessionID ?? properties.info?.id
          if (sessionID) clearSession(sessionID)
          break
        }
        case "permission.asked":
        case "permission.v2.asked": {
          if (properties.id && properties.sessionID) {
            pendingRequests.set(`permission:${properties.id}`, properties.sessionID)
          }
          break
        }
        case "permission.replied":
        case "permission.v2.replied": {
          if (properties.requestID) pendingRequests.delete(`permission:${properties.requestID}`)
          break
        }
        case "question.asked":
        case "question.v2.asked": {
          if (properties.id && properties.sessionID) {
            pendingRequests.set(`question:${properties.id}`, properties.sessionID)
          }
          break
        }
        case "question.replied":
        case "question.rejected":
        case "question.v2.replied":
        case "question.v2.rejected": {
          if (properties.requestID) pendingRequests.delete(`question:${properties.requestID}`)
          break
        }
        default:
          return
      }

      await publish()
    },
    dispose: async () => {
      await updates
      try {
        await $`tmux set-option -pu -t ${pane} @opencode_status`.quiet()
      } catch {
        // The pane may already have been destroyed.
      }
    },
  }
}
