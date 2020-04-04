package com.sudeshi.iorgkt.adapter

import android.view.View
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.sudeshi.iorgkt.db.model.Data
import kotlinx.android.synthetic.main.layout_recyclerview_model.view.*

class DataListViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
    fun bindView(data: Data) {
        itemView.dataTextViewName.text = data.name
        itemView.dataTextViewDate.text = "Date: $data.date"
        itemView.dataTextViewPriority.text = "Priority: $data.priority"
        Glide.with(itemView.context).load(data.pic_path).into(itemView.dataImage)
    }

}