package shekhovtsov.nikita.damnhackteam;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.TextView;

import com.parse.Parse;
import com.parse.ParseObject;

public class MainActivity extends AppCompatActivity {

    Button button_D, button_A, button_M, button_N;
    View arrow;
    FrameLayout frameLayout;
    TextView textView;
    int flag;

    // Метод для инициализации объектов activity_main.xml
    public void InitUI() {
        button_D          = findViewById(R.id.button_D);
        button_A          = findViewById(R.id.button_A);
        button_M          = findViewById(R.id.button_M);
        button_N          = findViewById(R.id.button_N);
        frameLayout       = findViewById(R.id.frameLayout);
        textView          = findViewById(R.id.textView);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Parse.initialize(this);
        flag = 1;
        InitUI();
        loadFragment(DFragment.newInstance());


    }

    // метод, изменяющий состояние FrameLayout, задающий отображаемый фрагмент
    private void loadFragment(Fragment fragment) {
        FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
        ft.replace(R.id.frameLayout, fragment);
        ft.commit();
    }

    // ниже функции, обрабатывающие события нажатия на кнопки
    // flag - переменная, которая блокирует повторноую инициализацию фрагмента
    public void on_letter_D_click(View view) {
        if (flag == 1) {
        } else {
            button_D.setAlpha((float) 1.0);
            button_A.setAlpha((float) 0.3);
            button_M.setAlpha((float) 0.3);
            button_N.setAlpha((float) 0.3);
            textView.setText("Дмитрий Петухов");
            loadFragment(DFragment.newInstance());
            flag = 1;
        }
    }

    public void on_letter_A_click(View view) {
        if (flag == 2) {
        } else {
            button_D.setAlpha((float) 0.3);
            button_A.setAlpha((float) 1.0);
            button_M.setAlpha((float) 0.3);
            button_N.setAlpha((float) 0.3);
            textView.setText("Александр Горностаев");
            loadFragment(AFragment.newInstance());
            flag = 2;
        }
    }

    public void on_letter_M_click(View view) {
        if (flag == 3) {
        } else {
            button_D.setAlpha((float) 0.3);
            button_A.setAlpha((float) 0.3);
            button_M.setAlpha((float) 1.0);
            button_N.setAlpha((float) 0.3);
            textView.setText("Максим Скрябин");
            loadFragment(MFragment.newInstance());
            flag = 3;
        }
    }

    public void on_letter_N_click(View view) {
        if (flag == 4) {
        } else {
            button_D.setAlpha((float) 0.3);
            button_A.setAlpha((float) 0.3);
            button_M.setAlpha((float) 0.3);
            button_N.setAlpha((float) 1.0);
            textView.setText("Никита Шеховцов");
            loadFragment(NFragment.newInstance());
            flag = 4;
        }
    }

}
