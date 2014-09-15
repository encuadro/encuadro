package com.Encuadro;

import java.util.List;

import com.example.qr.R;

import android.content.Context;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
 
public class ItemAdapter extends BaseAdapter {
 
    private Context context;
    private List<ItemList> items;
 
    public ItemAdapter(Context context, List<ItemList> items) {
        this.context = context;
        this.items = items;
    }
 
    @Override
    public int getCount() {
        return this.items.size();
    }
 
    @Override
    public Object getItem(int position) {
        return this.items.get(position);
    }
 
    @Override
    public long getItemId(int position) {
        return position;
    }
 
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
 
        View rowView = convertView;
 
        if (convertView == null) {
            // Create a new view into the list.
            LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            rowView = inflater.inflate(R.layout.puntaje_simple, parent, false);
        }
 
//         Set data into the view.
        TextView tv_nombre = (TextView) rowView.findViewById(R.id.textView2);
        TextView tv_puntaje = (TextView) rowView.findViewById(R.id.textView1);
        
        ItemList item = this.items.get(position);
        
        Integer p = item.getPuntaje();
        tv_puntaje.setText(p.toString());
        tv_nombre.setText(item.getNombre());;        
 
        return rowView;
    }
 
}
