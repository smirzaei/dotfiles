import { spawn } from "node:child_process"
import { Plugin } from "@opencode/plugin/tui"

type Status = "idle" | "busy" | "waiting" | "error"

const tmux = (args: string[]) =>
  new Promise<boolean>((resolve) => {
    const child = spawn("tmux", args, { stdio: "ignore" })
    child.once("error", () => resolve(false))
    child.once("close", (code) => resolve(code === 0))
  })

export default Plugin.define({
  id: "tmux-status",
  setup(ctx) {
    const pane = process.env.TMUX_PANE
    if (!process.env.TMUX || !pane || !/^%\d+$/.test(pane)) return

    const busySessions = new Set<string>()
    const errorSessions = new Set<string>()
    const pendingRequests = new Map<string, string>()
    const parents = new Map<string, string | undefined>()
    let selected: string | undefined
    let status: Status | undefined
    let updates = Promise.resolve()
    let stopped = false

    const root = (sessionID: string) => {
      const seen = new Set<string>()
      let id = sessionID
      while (!seen.has(id)) {
        seen.add(id)
        if (id === selected) return id
        const session = ctx.data.session.get(id)
        const parentID = session?.parentID ?? parents.get(id)
        if (!parentID) return session || parents.has(id) ? id : undefined
        id = parentID
      }
    }

    const publish = () => {
      if (stopped) return
      const next: Status =
        selected && errorSessions.has(selected)
          ? "error"
          : selected && [...pendingRequests.values()].some((sessionID) => root(sessionID) === selected)
            ? "waiting"
            : selected && busySessions.has(selected)
              ? "busy"
              : "idle"
      if (next === status) return

      status = next
      updates = updates.then(async () => {
        if (!(await tmux(["set-option", "-p", "-t", pane, "@opencode_status", next])) && status === next) {
          status = undefined
        }
      })
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

    const syncSelection = () => {
      const route = ctx.ui.router.current()
      const sessionID = route.type === "session" ? route.sessionID : undefined
      const next = sessionID && (root(sessionID) ?? sessionID)
      if (next === selected) return
      selected = next
      if (next) {
        if (ctx.data.session.status(next) === "running") busySessions.add(next)
        for (const member of [next, ...ctx.data.session.family(next)]) {
          if (root(member) !== next && member !== next) continue
          for (const request of ctx.data.session.permission.list(member) ?? []) {
            pendingRequests.set(`permission:${request.id}`, member)
          }
          for (const form of ctx.data.session.form.list(member) ?? []) {
            pendingRequests.set(`form:${form.id}`, member)
          }
        }
      }
      publish()
    }

    const stop = ctx.data.listen(({ details }) => {
      syncSelection()
      switch (details.type) {
        case "session.created":
          parents.set(details.data.sessionID, details.data.parentID)
          break
        case "session.execution.started":
          errorSessions.delete(details.data.sessionID)
          busySessions.add(details.data.sessionID)
          break
        case "session.execution.succeeded":
        case "session.execution.interrupted":
          markIdle(details.data.sessionID)
          break
        case "session.execution.failed":
        case "session.error": {
          const sessionID = details.data.sessionID
          if (!sessionID) return
          markIdle(sessionID)
          errorSessions.add(sessionID)
          break
        }
        case "session.deleted":
          markIdle(details.data.sessionID)
          errorSessions.delete(details.data.sessionID)
          parents.delete(details.data.sessionID)
          break
        case "permission.asked":
          pendingRequests.set(`permission:${details.data.id}`, details.data.sessionID)
          break
        case "permission.replied":
          pendingRequests.delete(`permission:${details.data.requestID}`)
          break
        case "form.created":
          pendingRequests.set(`form:${details.data.form.id}`, details.data.form.sessionID)
          break
        case "form.replied":
        case "form.cancelled":
          pendingRequests.delete(`form:${details.data.id}`)
          break
        default:
          return
      }

      publish()
    })

    publish()
    syncSelection()
    const poll = setInterval(syncSelection, 100)

    return async () => {
      stopped = true
      clearInterval(poll)
      stop()
      await updates
      await tmux(["set-option", "-pu", "-t", pane, "@opencode_status"])
    }
  },
})
