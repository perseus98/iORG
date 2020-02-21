package com.sudeshi.iorg.adapter;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Base64;
import android.view.LayoutInflater;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.appcompat.widget.PopupMenu;

import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.sudeshi.iorg.R;
import com.sudeshi.iorg.db_config.DBHandler;
import com.sudeshi.iorg.model.DataModel;
import com.sudeshi.iorg.model.MapTagModel;

import java.util.List;

public class DataItemAdapter extends BaseAdapter implements PopupMenu.OnMenuItemClickListener {


    private Context context;
    private List<DataModel> dataModelList;

    private DBHandler dbHandler;

    public DataItemAdapter(Context context, List<DataModel> dataModelList) {
        this.dataModelList = dataModelList;
        this.context = context;
        dbHandler = new DBHandler(context);
    }

    @Override
    public int getCount() {
        return dataModelList.size();
    }

    @Override
    public Object getItem(int position) {
        return dataModelList.get(position);
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        DataModel obj = dataModelList.get(position);
        LayoutInflater inflater = ((Activity) context).getLayoutInflater();
        View row = inflater.inflate(R.layout.adapter_data_item_layout, parent, false);
        TextView label = row.findViewById(R.id.tv_name);
        TextView tv_date = row.findViewById(R.id.tv_date);
        ImageView image_pic = row.findViewById(R.id.image_pic);
        final ImageView image_info = row.findViewById(R.id.image_info);
        label.setText(obj.getName());
        tv_date.setText(obj.getDate());

        if (!obj.getPic_path().equals("") || obj.getPic_path() != null) {
            setImageBitmap(obj.getPic_path(), image_pic, false);

        }
        image_pic.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dbHandler.insertMapTagData(new MapTagModel(1, 1, ""));
            }
        });


        image_info.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showPopup(image_info);
            }
        });
        return row;
    }


    public void showPopup(ImageView v) {
        PopupMenu popup = new PopupMenu(context, v);
        MenuInflater inflater = popup.getMenuInflater();
        popup.setOnMenuItemClickListener(this);
        inflater.inflate(R.menu.pop_up_menu, popup.getMenu());
        popup.show();
    }

    @Override
    public boolean onMenuItemClick(MenuItem item) {

        dialogDisplayACreateTag();
        switch (item.getItemId()) {
            case R.id.menu_view_image:
                //Toast.makeText(context, "image", Toast.LENGTH_SHORT).show();
                return true;
            case R.id.menu_view_tag:
                //  Toast.makeText(context, "tag", Toast.LENGTH_SHORT).show();
                return true;
            default:
                return false;
        }
    }


    private void dialogDisplayACreateTag() {

        BottomSheetDialog dialog = new BottomSheetDialog(context);
        dialog.setContentView(R.layout.dialog_layout_tag_list);

        GridView list_map_tag_item = dialog.findViewById(R.id.list_map_tag_item);
        getMapTagList(list_map_tag_item);

        dialog.show();

    }

    private void getMapTagList(GridView list_map_tag_item) {
        List<MapTagModel> mapTagModelList = dbHandler.getMapTagList("1");
        if (dataModelList.size() > 0) {
            MapTagListAdapter adapter = new MapTagListAdapter(context, mapTagModelList);
            list_map_tag_item.setAdapter(adapter);
            adapter.notifyDataSetChanged();
        }
    }

    private void setImageBitmap(String str_img, ImageView image_image, boolean isLive) {

//        final String url = str_img;
//        String final_url = "";
//
//        final String image_name = url.substring(url.lastIndexOf("/"), url.length()).replace("/", "").replace(" ", "%20");
//        String path = "";
//        try {
//            File mydir = new File(context.getApplicationContext().getFilesDir(), Environment.getExternalStorageDirectory().getAbsolutePath() + "/app_tempimages/");
//            if (!mydir.exists()) {
//                mydir.mkdirs();
//            }
//            File storagePath = mydir.getCanonicalFile();
//            path = storagePath + "/" + image_name;
//
//            File file_final = new File(path);
//            if (file_final.exists()) {
//                final_url = Uri.fromFile(new File(path)).toString().replace("%2520", "%20");
//            } else {
////                if (NetworkCheckActivity.isNetworkAvailable(mContext)) {
////                    new DownloadFileFromURL().execute(url.replace(" ", "%20"), path);
////                }
//                final_url = url;
//            }
//        } catch (Exception e) {
//        }

//        if (isLive) {
//
////            Picasso.with(context)
////                    .load(final_url)
////                    .placeholder(context.getResources().getDrawable(R.drawable.ic_launcher_background))
////                    .noFade()
////                    .error(context.getResources().getDrawable(R.drawable.ic_launcher_background))
////                    .into(image_image);
//
//
//        } else {
//
//        }

        byte[] decodedBytes = Base64.decode(str_img, Base64.DEFAULT);
        Bitmap bitmap = BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.length);
        image_image.setImageBitmap(bitmap);

    }
}
