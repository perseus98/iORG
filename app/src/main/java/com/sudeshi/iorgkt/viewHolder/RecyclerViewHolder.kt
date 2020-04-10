package com.sudeshi.iorgkt.adapter

import android.view.View
import android.widget.FrameLayout
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.sudeshi.iorgkt.R.id
import com.sudeshi.iorgkt.db.model.Data
import com.sudeshi.iorgkt.viewHolder.ViewHolderClickListener
import kotlinx.android.synthetic.main.layout_recyclerview_model.view.*

class RecyclerViewHolder(itemView: View, var r_tap: ViewHolderClickListener) :
    RecyclerView.ViewHolder(itemView), View.OnLongClickListener, View.OnClickListener {
    val recyclerViewModel: FrameLayout = itemView.findViewById(id.recyclerViewModel)
    fun bindView(data: Data) {
        itemView.dataTextViewName.text = data.name
        itemView.dataTextViewDate.text = data.date.toString()
        itemView.dataTextViewPriority.text = data.priority.toString()
        Glide.with(itemView.context).load(data.pic_path).into(itemView.dataImage)
    }

    init {
        recyclerViewModel.setOnClickListener(this)
        recyclerViewModel.setOnLongClickListener(this)
    }

    override fun onClick(v: View?) {
        r_tap.onTap(adapterPosition)
    }

    override fun onLongClick(v: View?): Boolean {
        r_tap.onLongTap(adapterPosition)
        return true
    }
}