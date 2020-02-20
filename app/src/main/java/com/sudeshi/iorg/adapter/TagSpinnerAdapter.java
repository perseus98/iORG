package com.sudeshi.iorg.adapter;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.sudeshi.iorg.R;
import com.sudeshi.iorg.model.TagModel;

import java.util.List;

public class TagSpinnerAdapter extends BaseAdapter {


    private Context context;
    private List<TagModel> tagModelList;

    public TagSpinnerAdapter(Context context, List<TagModel> tagModelList) {
        this.tagModelList = tagModelList;
        this.context = context;
    }

    @Override
    public int getCount() {
        return tagModelList.size();
    }

    @Override
    public Object getItem(int position) {
        return tagModelList.get(position);
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        TagModel obj = tagModelList.get(position);
        LayoutInflater inflater = ((Activity) context).getLayoutInflater();
        View row = inflater.inflate(R.layout.spinner_layout, parent, false);
        TextView label = (TextView) row.findViewById(R.id.tv_name);
        label.setText(obj.getName());
        return row;
    }
}
