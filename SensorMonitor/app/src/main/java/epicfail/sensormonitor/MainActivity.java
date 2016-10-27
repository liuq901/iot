package epicfail.sensormonitor;

import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import org.w3c.dom.Text;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class MainActivity extends AppCompatActivity implements SensorEventListener {

    boolean hidden = true;
    Button button = null;
    TextView sensorInfo = null;
    SensorManager sensorManager = null;
    List <Sensor> sensorList = null;
    Map <String, float []> sensorValue = null;

    String getName()
    {
        String text = "";
        for (Sensor sensor : sensorList)
            text += sensor.getName() + "\n";
        return text;
    }

    String getValue()
    {
        String text = "";
        for (Sensor sensor : sensorList)
        {
            String name = sensor.getName();
            text += name + "\n";
            float values[] = sensorValue.get(sensor.getName());
            if (values != null)
                for (float value : values)
                    text += value + "\n";
            text += "\n";
        }
        return text;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        button = (Button) findViewById(R.id.button);
        sensorInfo = (TextView) findViewById(R.id.sensorInfo);
        sensorManager = (SensorManager) getSystemService(SENSOR_SERVICE);
        sensorList = sensorManager.getSensorList(Sensor.TYPE_ALL);
        sensorValue = new HashMap <String, float []>();

        sensorInfo.setText(getName());

        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (hidden)
                {
                    hidden = false;
                    button.setText("Hide value");
                    sensorInfo.setText(getValue());
                }
                else
                {
                    hidden = true;
                    button.setText("Show value");
                    sensorInfo.setText(getName());
                }
            }
        });

        for (Sensor sensor : sensorList)
            sensorManager.registerListener(this, sensor, SensorManager.SENSOR_DELAY_NORMAL);
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        String sensorname = event.sensor.getName();
        sensorValue.put(sensorname, event.values.clone());
        if (!hidden)
            sensorInfo.setText(getValue());
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {

    }
}
