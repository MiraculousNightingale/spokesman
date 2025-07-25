// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

let hooks = {
  TextAreaSubmitOnEnter: {
    mounted() {
      this.el.addEventListener("keydown", (e) => {
        if (e.key === "Enter" && !e.shiftKey) {
          e.preventDefault()
          this.el.form.requestSubmit()
        }
      })
    },
  },

  ScrollDownOnNewMessage: {
    mounted() {
      this.handleEvent("spokesman:chat_message_added", (e) => {
        this.el.scrollTop = this.el.scrollHeight
      })

      this.observer = new MutationObserver(() => this.maybeScrollToBottom());
      this.observer.observe(this.el, { childList: true });
    },
    destroyed() {
      this.observer.disconnect();
    },

    scrollToBottom() {
      this.el.scrollTop = this.el.scrollHeight
    },

    maybeScrollToBottom() {
      let maxScroll = this.el.scrollHeight - this.el.clientHeight,
        scrollPercentage = this.el.scrollTop / maxScroll

      console.log(`SCROLL PERCENTAGE ${scrollPercentage}`)

      if (scrollPercentage >= 0.9) {
        this.scrollToBottom()
      }
    }
  },

  HighlightSelectedChat: {
    mounted() {
      this.handleEvent("spokesman:chat_selected", (e) => {

        const previousSelectedChat = this.el.querySelector('.selected-chat')
        previousSelectedChat?.classList.replace("selected-chat", "unselected-chat")

        const newSelectedChat = this.el.querySelector(`#chats-${e.chat_id} .unselected-chat`)
        newSelectedChat?.classList.replace("unselected-chat", "selected-chat")
      })
    }
  }
}


let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: hooks,
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

