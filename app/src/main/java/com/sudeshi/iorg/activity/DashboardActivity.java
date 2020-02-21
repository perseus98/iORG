package com.sudeshi.iorg.activity;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.cardview.widget.CardView;

import com.sudeshi.iorg.R;
import com.sudeshi.iorg.db_config.DBHandler;
import com.sudeshi.iorg.model.DataModel;

import java.util.List;

public class DashboardActivity extends AppCompatActivity {

    private CardView card_view_create;
    private CardView card_view_add_tag;
    private TextView tv_tag_text;
    private DBHandler dbHandler;
    private EditText et_tag_name;
    private Button btn_add;
    private Dialog dialog;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_dashboard);
        card_view_create = findViewById(R.id.card_view_create);
        tv_tag_text = findViewById(R.id.tv_tag_text);
        card_view_add_tag = findViewById(R.id.card_view_add_tag);
        View.OnClickListener clickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                createIntent();
            }
        };

        card_view_create.setOnClickListener(clickListener);
        dbHandler = new DBHandler(this);

        card_view_add_tag.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                dialogDisplayACreateTag();
            }
        });
    }

    private void dialogDisplayACreateTag() {

        dialog = new Dialog(this);
        dialog.setContentView(R.layout.dialog_layout_add_tag);

        et_tag_name = dialog.findViewById(R.id.et_tag_name);
        btn_add = dialog.findViewById(R.id.btn_add);

        btn_add.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                validateField();
            }
        });

        dialog.show();

    }

    private void validateField() {
        if (et_tag_name.getText().toString().trim().isEmpty()) {
            Toast.makeText(this, "Please enter tag", Toast.LENGTH_SHORT).show();
        } else {
            if (dbHandler.insertTag(et_tag_name.getText().toString().trim()) != -1) {
                et_tag_name.setText("");
                dialog.dismiss();
                Toast.makeText(this, "Tag added successfully", Toast.LENGTH_SHORT).show();
            } else {
                Toast.makeText(this, "Sorry!!!!!", Toast.LENGTH_SHORT).show();
            }

        }
    }

    private void createIntent() {
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
                dbHandler.insertData(new DataModel(i, "name" + i, "path" + i, "date" + i, i));
            }

//            dbHandler.insertData(new DataModel(0, "name", "path", "date", 0, tagLastID));

            getData();

        } catch (Exception e) {
            Toast.makeText(this, "" +
                    e.getMessage(), Toast.LENGTH_SHORT).show();
        }
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
