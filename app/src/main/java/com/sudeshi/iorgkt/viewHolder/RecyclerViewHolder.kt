package com.sudeshi.iorgkt.viewHolder

import android.content.Context
import android.content.res.TypedArray
import android.view.View
import android.widget.FrameLayout
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.sudeshi.iorgkt.R
import com.sudeshi.iorgkt.R.id
import com.sudeshi.iorgkt.db.model.Data
import kotlinx.android.synthetic.main.layout_recyclerview_model.view.*
import java.time.format.DateTimeFormatter
import java.time.format.FormatStyle

class RecyclerViewHolder(itemView: View, private var r_tap: ViewHolderClickListener) :
    RecyclerView.ViewHolder(itemView), View.OnLongClickListener, View.OnClickListener {
    val recyclerViewModel: FrameLayout = itemView.findViewById(id.recyclerViewModel)
    val context: Context = itemView.context
    private val priorityColorArray: TypedArray =
        context.resources.obtainTypedArray(R.array.priority_colour)
    fun bindView(data: Data) {
        itemView.dataTextViewName.text = data.name
        itemView.dataTextViewDate.text = data.date.format(
            DateTimeFormatter.ofLocalizedDateTime(
                FormatStyle.MEDIUM
            )
        )
        itemView.dataTextViewPriority.text = data.priority.toString()
        // PRIORITY color logiczzzzz
        itemView.background = priorityColorArray.getDrawable(data.priority)
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