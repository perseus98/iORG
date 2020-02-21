package com.sudeshi.iorg.adapter;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.sudeshi.iorg.R;
import com.sudeshi.iorg.db_config.DBHandler;
import com.sudeshi.iorg.model.MapTagModel;

import java.util.List;

public class MapTagListAdapter extends BaseAdapter {


    private Context context;
    private List<MapTagModel> mapTagModelList;

    private DBHandler dbHandler;

    public MapTagListAdapter(Context context, List<MapTagModel> mapTagModelList) {
        this.mapTagModelList = mapTagModelList;
        this.context = context;
        dbHandler = new DBHandler(context);
    }

    @Override
    public int getCount() {
        return mapTagModelList.size();
    }

    @Override
    public Object getItem(int position) {
        return mapTagModelList.get(position);
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        MapTagModel obj = mapTagModelList.get(position);
        LayoutInflater inflater = ((Activity) context).getLayoutInflater();
        View row = inflater.inflate(R.layout.adapter_data_item_layout, parent, false);
        TextView label = row.findViewById(R.id.tv_name);
        TextView tv_date = row.findViewById(R.id.tv_date);
        ImageView image_pic = row.findViewById(R.id.image_pic);
        final ImageView image_info = row.findViewById(R.id.image_info);
        label.setText(obj.getName());

        return row;
    }
}
