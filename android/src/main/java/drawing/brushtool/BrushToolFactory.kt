package com.ttv.drawingboard.drawing.brushtool

import com.ttv.drawingboard.drawing.BoardContext
import com.ttv.drawingboard.drawing.brushtool.model.BrushConfig
import com.ttv.drawingboard.drawing.brushtool.renderer.StampRendererFactory

class BrushToolFactory(
    private val brushToolBitmaps: BrushToolBitmaps,
    private val boardContext: BoardContext
) {

    private var stampRendererFactory = StampRendererFactory(brushToolBitmaps.strokeBitmap)

    fun create(brushColor: Int, brushConfig: BrushConfig): BrushTool {
        return BrushTool(
            boardContext = boardContext,
            stampRendererFactory.create(brushColor, brushConfig),
            ResultBitmapUpdater(
                brushToolBitmaps,
                brushConfig,
            ),
            brushConfig.step,
        )
    }

}