package expo.modules.onvodrawingboard

import android.content.Context
import expo.modules.kotlin.AppContext
import expo.modules.kotlin.viewevent.EventDispatcher
import expo.modules.kotlin.views.ExpoView
import com.ttv.drawingboard.drawing.DrawingView

class OnvoDrawingBoardView(context: Context, appContext: AppContext) : ExpoView(context, appContext) {

    private val onTouchEvent by EventDispatcher()

    internal val drawingView = DrawingView(context).apply {
        layoutParams = LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT)
    }

    init {
        addView(drawingView)
        setupTouchListeners()
    }
 
    private fun setupTouchListeners() {
        drawingView.setOnTouchListener { _, event ->
            onTouchEvent(mapOf(
                "action" to event.actionMasked,
                "x" to event.x,
                "y" to event.y
            ))
            true
        }
    }

    fun resetTransformation() {
        drawingView.resetTransformation()
    }

    fun updateRenderer() {
        // drawingView.updateRenderer()
    }
}