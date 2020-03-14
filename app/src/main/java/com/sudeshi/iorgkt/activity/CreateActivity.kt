package com.sudeshi.iorgkt.activity

import android.app.Activity
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore.ACTION_IMAGE_CAPTURE
import android.provider.MediaStore.EXTRA_OUTPUT
import android.util.Log
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.FileProvider
import com.sudeshi.iorgkt.R
import kotlinx.android.synthetic.main.activity_create.*
import java.io.File
import java.io.IOException
import java.text.SimpleDateFormat
import java.util.*


class CreateActivity : AppCompatActivity() {

    lateinit var currentPhotoPath: String

    val REQUEST_IMAGE_CAPTURE = 1
    val REQUEST_TAKE_PHOTO = 1
    val TAG: String = "CreateActivity"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_create)
        btn_captureImg.setOnClickListener {
            dispatchTakePictureIntent()
//            Toast.makeText(applicationContext,"Picture Okk",Toast.LENGTH_LONG).show()

        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (resultCode != Activity.RESULT_CANCELED) {
            if (requestCode == REQUEST_TAKE_PHOTO) {
                try {
                    val uri = intent.data
                    var bitmap: Bitmap?

                    try {
//                        bitmap = MediaStore.Images.Media.getBitmap(this.getContentResolver(), uri);
//                        bitmap = Images.Media(this.contentResolver, uri)
                        bitmap = BitmapFactory.decodeFile(currentPhotoPath)
                        btn_captureImg.setImageBitmap(bitmap)
                        Log.d(TAG, bitmap.toString())

                    } catch (e: IOException) {
                        e.printStackTrace()
                    }

//                    Log.d(TAG, photoURI.toString())
//                    val imageBitmap = data?.extras?.get("data") as Bitmap
                } catch (e: Exception) {

                    Log.d(TAG, e.toString())
                }
            }

        }
    }

    private fun dispatchTakePictureIntent() {
        Intent(ACTION_IMAGE_CAPTURE).also { takePictureIntent ->
            // Ensure that there's a camera activity to handle the intent
            takePictureIntent.resolveActivity(packageManager)?.also {
                // Create the File where the photo should go
                val photoFile: File? = try {
                    createImageFile()
                } catch (ex: IOException) {
                    // Error occurred while creating the File
                    Toast.makeText(
                        applicationContext,
                        "Counldn't create/take picture",
                        Toast.LENGTH_LONG
                    ).show()
                    null
                }
                // Continue only if the File was successfully created
                photoFile?.also {
                    val photoURI: Uri = FileProvider.getUriForFile(
                        this,
                        "com.sudeshi.iorgkt.fileprovider",
                        it
                    )

                    takePictureIntent.putExtra(EXTRA_OUTPUT, photoURI)
                    startActivityForResult(takePictureIntent, REQUEST_TAKE_PHOTO)
                }
            }
        }
    }

    @Throws(IOException::class)
    private fun createImageFile(): File {
        // Create an image file name
        val timeStamp: String = SimpleDateFormat("yyyyMMdd_HHmmss").format(Date())
        val storageDir: File? = getExternalFilesDir(Environment.DIRECTORY_PICTURES)
        return File.createTempFile(
            "JPEG_${timeStamp}_", /* prefix */
            ".jpg", /* suffix */
            storageDir /* directory */
        ).apply {
            // Save a file: path for use with ACTION_VIEW intents
            currentPhotoPath = absolutePath
        }
    }

}