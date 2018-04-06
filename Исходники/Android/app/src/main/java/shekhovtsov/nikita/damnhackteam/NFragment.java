package shekhovtsov.nikita.damnhackteam;


import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RatingBar;
import android.widget.Toast;

import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseQuery;


/**
 * A simple {@link Fragment} subclass.
 */
public class NFragment extends Fragment {

    RatingBar ratingBar;


    public NFragment() {
    }

    // метод инициализирующий фрагмент
    public static NFragment newInstance() {
        Bundle args = new Bundle();
        NFragment fragment = new NFragment();
        fragment.setArguments(args);
        return fragment;
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_n, container, false);

        // выполняем загрузку данных с сервера и пулим в RatingBar
        ratingBar = view.findViewById(R.id.ratingBar_N);
        final ParseQuery<ParseObject> query = ParseQuery.getQuery("damn");
        query.whereEqualTo("username_id", 4);
        try {
            ParseObject object = query.getFirst();
            Double rate = object.getDouble("rating");
            ratingBar.setRating(Float.parseFloat(new Double(rate).toString()));
        } catch (ParseException e) {
            Toast toast = Toast.makeText(view.getContext(), "Error getting data", Toast.LENGTH_SHORT);
            toast.show();
        }

        // после загрузки данных с сервака их можно изменить, для этого перегружен метод onRatingChanged
        ratingBar.setOnRatingBarChangeListener(new RatingBar.OnRatingBarChangeListener() {
            @Override
            public void onRatingChanged(RatingBar ratingBar, float v, boolean b) {
                try {
                    ParseObject object = query.getFirst();
                    object.put("rating", (double) v);
                    object.save();
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }
        });
        return view;
    }

}
