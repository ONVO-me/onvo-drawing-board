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
            "PI" to Math.PI 
        )


        Function("undoAction") {
           
        }

        Function("redoAction") {
           
        }

        Function("toggleToolPickerVisibility") {
             // toggle tools here
        }

        Function("saveImageToPhotos") {
            // save image to photos
        }
        
       Function("isDrawingTooSimple") { 
        // return bool if drawing is too small
       }
        
       AsyncFunction("getDrawing") {
        // return base 64
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