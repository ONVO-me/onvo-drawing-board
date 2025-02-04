package expo.modules.onvodrawingboard

import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.util.Base64
import java.io.ByteArrayOutputStream

class OnvoDrawingBoardModule : Module() {
    override fun definition() = ModuleDefinition {
        Name("OnvoDrawingBoard")

        Constants(
            "PI" to Math.PI // Example constant, can be removed if not needed
        )

        // Define events that the module can send to JavaScript
        Events("onChange", "onTouchEvent")

        // Example synchronous function
        Function("hello") {
            "Hello from OnvoDrawingBoardModule!"
        }

        // Example asynchronous function
        AsyncFunction("resetDrawing") { viewTag: Int ->
            // Find the view by its tag and reset its transformation
            val view = appContext.findView<OnvoDrawingBoardView>(viewTag)
            view?.resetTransformation()
        }

        AsyncFunction("getDrawingAsBase64") { viewTag: Int ->
            // Find the view by its tag and capture its drawing as a Base64-encoded image
            val view = appContext.findView<OnvoDrawingBoardView>(viewTag)
            view?.getDrawingAsBase64()
        }

        // Define the native view component
        View(OnvoDrawingBoardView::class) {
            // Define props for the view (if needed)
            Prop("backgroundColor") { view: OnvoDrawingBoardView, color: String ->
                view.setBackgroundColor(Color.parseColor(color))
            }

            // Define events that the view can send to JavaScript
            Events("onTouchEvent")
        }
    }
}