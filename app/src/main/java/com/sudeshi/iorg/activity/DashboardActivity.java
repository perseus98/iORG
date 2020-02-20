package com.sudeshi.iorg.activity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.sudeshi.iorg.R;
import com.sudeshi.iorg.db_config.DBHandler;
import com.sudeshi.iorg.model.DataModel;

import java.util.List;

public class DashboardActivity extends AppCompatActivity {

    private ImageView image_create;
    private ImageView image_save;
    private TextView tv_tag_text;
    private DBHandler dbHandler;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_dashboard);
        image_create = findViewById(R.id.image_create);
        tv_tag_text = findViewById(R.id.tv_tag_text);
        image_save = findViewById(R.id.image_save);
        View.OnClickListener clickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                createIntent();
            }
        };

        image_create.setOnClickListener(clickListener);
        dbHandler = new DBHandler(this);

        image_save.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                for (int i = 0; i < 5; i++) {
                    dbHandler.insertTag("Val" + i);
                }
            }
        });
    }

    private void createIntent() {

//        try {
//
//
//            for (int i = 0; i < 5; i++) {
//
//                createDataIntent(dbHandler.insertTag("Val" + i));
//            }
//
//
//        } catch (Exception e) {
//            Toast.makeText(this, "" +
//                    e.getMessage(), Toast.LENGTH_SHORT).show();
//        }

        //Toast.makeText(this, "aaya", Toast.LENGTH_SHORT).show();
        startActivity(new Intent(DashboardActivity.this, CreateEventActivity.class));

    }

//    private void getTag() {
//        String tag_name = "";
//
//        List<TagModel> tagModelList = dbHandler.getTagList();
//        if (tagModelList.size() > 0) {
//
//            for (int i = 0; i < tagModelList.size(); i++) {
//                tag_name += tagModelList.get(i).getName() + "/";
//            }
//        }
//
//        tv_tag_text.setText(tag_name);
//    }


    private void createDataIntent(long tagLastID) {

        try {


            for (int i = 0; i < 5; i++) {
                dbHandler.insertData(new DataModel(i, "name" + i, "path" + i, "date" + i, i, tagLastID));
            }


//            dbHandler.insertData(new DataModel(0, "name", "path", "date", 0, tagLastID));

            getData();

        } catch (Exception e) {
            Toast.makeText(this, "" +
                    e.getMessage(), Toast.LENGTH_SHORT).show();
        }

        //Toast.makeText(this, "aaya", Toast.LENGTH_SHORT).show();
        //startActivity(new Intent(DashboardActivity.this, CreateEventActivity.class));


    }

    private void getData() {
        String tag_name = "";

        List<DataModel> dataModelList = dbHandler.getDataList();
        if (dataModelList.size() > 0) {

            for (int i = 0; i < dataModelList.size(); i++) {
                tag_name += dataModelList.get(i).getName() + "/";
            }
        }

        tv_tag_text.setText(tag_name);
    }


}
