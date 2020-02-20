package com.sudeshi.iorg.adapter;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Base64;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.sudeshi.iorg.R;
import com.sudeshi.iorg.model.DataModel;

import java.util.List;

public class DataItemAdapter extends BaseAdapter {


    private Context context;
    private List<DataModel> dataModelList;

    public DataItemAdapter(Context context, List<DataModel> dataModelList) {
        this.dataModelList = dataModelList;
        this.context = context;
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
        ImageView image_pic = row.findViewById(R.id.image_pic);
        label.setText(obj.getName());

        if (!obj.getPic_path().equals("") || obj.getPic_path() != null) {
            setImageBitmap(obj.getPic_path(), image_pic, false);

        }
        return row;
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
