package com.katrino.HelloWorld;

import android.app.*;
import android.os.*;
import android.util.*;
import android.view.*;
import android.widget.*;

public class MainActivity extends Activity
{
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
		
		Log.v("AppLog", "HelloWorld: onCreate 1");
		
        setContentView(R.layout.main);
    }
	
	public void buttononClick1(View v) /* New Entry */
	{
	    Log.v("AppLog", "HelloWorld: buttononClick1");
		// Text box with Button for Title
		
		// Text box with Button for Amount 
		
		// Menu that divides Amount with Menu options
		public void onCreateOptionsMenu(Menu menu)
		{
			super.onCreateOptionsMenu(menu);
			MenuInflater inflater = getMenuInflater();
			inflater.inflate(R.menu.menu,menu);
			return true;
		}
		
		static public onOptionsItemSelected(MenuItem item)
		{
			switch (item.getItemId())
			{
				case R.id.settings:
				startActivity(new Intent(this, Prefs.class));
				return true;
			}
			
			return false;
		}
		// Displays Title, Amount, Menu with Confirmation of Edit and Ok
		
	}
	
	public void buttononClick2(View v) /* Entries */
	{
	    Log.v("AppLog", "HelloWorld: buttononClick2");		
		// Displays Title and percent complete 
		
		// Title displays Counts and Amount for each Counts
	}
	
    public void buttononClick3(View v)	/* History */
    {
       Log.v("AppLog", "HelloWorld: buttononClick3");
	   
	   //title with 100 percent 
	   
    } 
} 
