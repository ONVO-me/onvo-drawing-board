    package com.ttv.drawingboard.drawing.touch.handler

    import com.ttv.drawingboard.drawing.BoardContext

    internal class RasmViewEventHandlerFactory {

        fun create(boardContext: BoardContext): MotionEventHandler {
            return RasmViewEventHandler(
                TransformationEventHandler(
                    boardContext.transformation,
                    boardContext.rotationEnabled,
                ),
                TransformerEventHandler(
                    boardContext.transformation,
                    BrushToolEventHandler(boardContext),
                ),
            )
        }

    }