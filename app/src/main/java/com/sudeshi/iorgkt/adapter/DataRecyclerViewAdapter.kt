package com.sudeshi.iorgkt.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.sudeshi.iorgkt.R
import com.sudeshi.iorgkt.db.model.Data

class DataRecyclerViewAdapter : RecyclerView.Adapter<RecyclerView.ViewHolder>() {
    private var dataList = listOf<Data>()
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
        return DataListViewHolder(
            LayoutInflater.from(parent.context)
                .inflate(R.layout.layout_recyclerview_model, parent, false)
        )
    }

    override fun getItemCount(): Int = dataList.size

    override fun onBindViewHolder(viewHolder: RecyclerView.ViewHolder, position: Int) {
        val dataViewHolder = viewHolder as DataListViewHolder
        dataViewHolder.bindView(dataList[position])
    }

    fun setDataList(dataList: List<Data>) {
        this.dataList = dataList
        notifyDataSetChanged()
    }
}