package com.ttv.drawingboard.drawing.actions

import com.ttv.drawingboard.drawing.BoardContext


internal interface Action {

    val size get() = 0

    /**
     * Move the context from state A to B.
     */
    fun perform(context: BoardContext)

    /**
     * Should be called in state A (before calling perform(context))
     * @return an action that move the context from state B to A.
     */
    fun getOppositeAction(context: BoardContext): Action

}
