import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["bubble"]

    connect() {
        this.activeTrigger = null

        // Remove any legacy native tooltips inside this table so they
        // cannot appear over the shared instant tooltip.
        this.element
            .querySelectorAll("[title]")
            .forEach((element) => {
                element.removeAttribute("title")
            })
    }

    show(event) {
        const trigger = event.target.closest(
            "[data-table-tooltip-text]"
        )

        if (!trigger || !this.element.contains(trigger)) return

        const text = trigger.dataset.tableTooltipText
        if (!text) return

        // Prevent a legacy native browser tooltip appearing over ours.
        trigger.removeAttribute("title")

        this.activeTrigger = trigger
        this.bubbleTarget.textContent = text
        this.bubbleTarget.classList.remove("hidden")

        this.position(event, trigger)
    }

    move(event) {
        if (!this.activeTrigger) return

        this.position(event, this.activeTrigger)
    }

    hide(event) {
        if (!this.activeTrigger) return

        const relatedTarget = event.relatedTarget

        if (
            relatedTarget &&
            this.activeTrigger.contains(relatedTarget)
        ) {
            return
        }

        this.bubbleTarget.classList.add("hidden")
        this.activeTrigger = null
    }

    closeWithKeyboard(event) {
        if (event.key !== "Escape") return

        this.bubbleTarget.classList.add("hidden")
        this.activeTrigger = null
    }

    position(event, trigger) {
        const triggerRect = trigger.getBoundingClientRect()
        const bubbleRect = this.bubbleTarget.getBoundingClientRect()
        const margin = 12

        const pointerEvent = event.type.startsWith("pointer")

        let left = pointerEvent ?
            event.clientX + margin :
            triggerRect.left

        let top = pointerEvent ?
            event.clientY + margin :
            triggerRect.bottom + 8

        if (left + bubbleRect.width > window.innerWidth - margin) {
            left = window.innerWidth - bubbleRect.width - margin
        }

        if (top + bubbleRect.height > window.innerHeight - margin) {
            top = pointerEvent ?
                event.clientY - bubbleRect.height - margin :
                triggerRect.top - bubbleRect.height - 8
        }

        left = Math.max(margin, left)
        top = Math.max(margin, top)

        this.bubbleTarget.style.left = `${left}px`
        this.bubbleTarget.style.top = `${top}px`
    }
}
