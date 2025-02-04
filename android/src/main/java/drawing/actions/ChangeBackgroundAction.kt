package com.raed.rasmview.actions

import com.ttv.drawingboard.drawing.BoardContext
import com.ttv.drawingboard.drawing.actions.Action

internal class ChangeBackgroundAction(
    private val newColor: Int,
): Action {

    override fun perform(context: BoardContext) {
        context.backgroundColor = newColor
    }

    override fun getOppositeAction(context: BoardContext): Action {
        return ChangeBackgroundAction(context.backgroundColor)
    }

}
