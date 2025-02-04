package com.ttv.drawingboard.drawing.brushtool.handler

import com.ttv.drawingboard.drawing.brushtool.model.TouchEvent

    internal class RulerTouchHandler(private val nextHandler: TouchHandler) : TouchHandler {
    private var startEvent: TouchEvent? = null

    override fun handleFirstTouch(event: TouchEvent) {
        startEvent = TouchEvent().apply { set(event) }
        nextHandler.handleFirstTouch(event)
    }

    override fun handleTouch(event: TouchEvent) {
        // Capture the current end point during movement for preview
        startEvent?.let { start ->
            nextHandler.handleFirstTouch(start)
            nextHandler.handleLastTouch(event)
            // Optional: Add logic to clear previous preview if supported
        }
    }

    override fun handleLastTouch(event: TouchEvent) {
        startEvent?.let { start ->
            nextHandler.handleFirstTouch(start)
            nextHandler.handleLastTouch(event)
        }
        startEvent = null
    }
}