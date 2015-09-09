
/* Definitions */
#define APP_MAIN_MMI_HELP_TITLE    "MMI Help (robot_line_1.pde)\n"

/* Wheel Definitions */
#define APP_WHEEL_LEFT_FORWARD_PIN      QK_MCU_PIN_PD2   /* PD2, MCU pin 4.           */
#define APP_WHEEL_LEFT_BACKWARD_PIN     QK_MCU_PIN_PB2   /* PB2, MCU pin16. OC1B/SS   */
#define APP_WHEEL_RIGHT_FORWARD_PIN     QK_MCU_PIN_PB1   /* PB1, MCU pin 15. OC1A     */
#define APP_WHEEL_RIGHT_BACKWARD_PIN    QK_MCU_PIN_PB0   /* PB0, MCU pin 14.          */

/* IR Sensor MCU I/O Pins */
#define APP_IR_TRANSMITTER_LEFT_2       QK_MCU_PIN_PD7   /* Socket1 pin 1 (blue), PD7, MCU pin 13, MCU wire 1, IR wire 1 */
#define APP_IR_RECEIVER_LEFT_2          QK_MCU_PIN_PC1   /* Socket1 pin 7 (yell), PC1, MCU pin 24, MCU wire 1, IR wire 1 */
                                                                                                                           
#define APP_IR_TRANSMITTER_LEFT_1       QK_MCU_PIN_PD6   /* Socket1 pin 2 (blue), PD6, MCU pin 12, MCU wire 4, IR wire 1.5 */
#define APP_IR_RECEIVER_LEFT_1          QK_MCU_PIN_PC2   /*               (yell), PC2, MCU pin 25, MCU wire 4, IR wire 1.5 */

#define APP_IR_TRANSMITTER_CENTER       QK_MCU_PIN_PD3   /* Socket1 pin 5 (blue), PD3, MCU pin 5 , MCU wire 2, IR wire 2 */
#define APP_IR_RECEIVER_CENTER          QK_MCU_PIN_PC0   /* Socket1 pin 8 (yell), PC0, MCU pin 23, MCU wire 2, IR wire 2 */

#define APP_IR_TRANSMITTER_RIGHT_1      QK_MCU_PIN_PD5   /* Socket1 pin 3 (blue), PD5, MCU pin 11, MCU wire 3, IR wire 2.5 */
#define APP_IR_RECEIVER_RIGHT_1         QK_MCU_PIN_PC3   /* Socket1 pin 9 (yell), PC3, MCU pin 26, MCU wire 3, IR wire 2.5 */

#define APP_IR_TRANSMITTER_RIGHT_2      QK_MCU_PIN_PD4   /* Socket1 pin 4 (blue), PD4, MCU pin 6, MCU wire 5, IR wire 3 */
#define APP_IR_RECEIVER_RIGHT_2         QK_MCU_PIN_PC4   /* Socket1 pin 9 (yell), PC4, MCU pin 27, MCU wire 5, IR wire 3 */

/* IR Sensor Calibration Values */
#define APP_IR_CAL_NUM_SAMPLES_MAX      5
#define APP_IR_CAL_SAMPLE_MARGIN        10

#define APP_IR_CAL_VAL_TRACK_MIN       (1010 - APP_IR_CAL_SAMPLE_MARGIN)
#define APP_IR_CAL_VAL_TRACK_MAX       (1021 + APP_IR_CAL_SAMPLE_MARGIN)

#define APP_IR_CAL_VAL_BACKGROUND_MIN  (801 - APP_IR_CAL_SAMPLE_MARGIN)
#define APP_IR_CAL_VAL_BACKGROUND_MAX  (805 + APP_IR_CAL_SAMPLE_MARGIN)

/* State definitions. */
enum
{
   APP_ROBOT_ST_OFF = 0,
   APP_ROBOT_ST_IDLE,
   APP_ROBOT_ST_STRAIGHT_START_FORWARD,
   APP_ROBOT_ST_STRAIGHT_GOING_FORWARD,
   APP_ROBOT_ST_STRAIGHT_START_RECOVERY,
   APP_ROBOT_ST_STRAIGHT_RECOVERY_START_LEFT,
   APP_ROBOT_ST_STRAIGHT_RECOVERY_GOING_LEFT,
   APP_ROBOT_ST_STRAIGHT_RECOVERY_START_RIGHT,
   APP_ROBOT_ST_STRAIGHT_RECOVERY_GOING_RIGHT,
   APP_ROBOT_ST_PANIC,
   APP_ROBOT_ST_MAX
};


/******************************************************************************
 ******************************************************************************/
typedef struct AppMain
{
   /* Place private variables here. */
   QK_UtlMmi       mmi;
   QK_UtlWheelD    wheelD;

   int state;
   int ir_cal_val_track_min;
   int ir_cal_val_track_max;

} AppMain;

/******************************************************************************
 ******************************************************************************/
/* Functions Definitions */
void QK_AppMain_mmi_help(void);
int  QK_AppMain_mmi_cmd_cb_handler(CBarg cb_mmi,
                                   CBarg cb_cmdbuf,
                                   CBarg arg2,
                                   CBarg arg3);

void QK_AppMain_ir_sensor_init(void);
int  QK_AppMain_ir_sensor_left_2(void);
int  QK_AppMain_ir_sensor_left_1(void);
int  QK_AppMain_ir_sensor_center(void);
int  QK_AppMain_ir_sensor_right_1(void);
int  QK_AppMain_ir_sensor_right_2(void);

Bool is_on_track(int sample);
void ir_sensor_auto_calibrate(void);

/* Global Variables */
AppMain Glb_AppMain;

void setup()
{
   /*------------------------- LOCAL VARIABLES -------------------------------*/ 
   /*------------------------------ CODE -------------------------------------*/
   /* Initialize main object. */
   memset(&Glb_AppMain, 0, sizeof(AppMain));
   
   /* Initialize the serial port. */
   QK_UtlUsart_init((Uword)QK_USART_BAUD_9600);
   QK_printf("\n\n\n");

   /* Place private initialization here. */

   /* Initialize the IR sensor. */
   QK_AppMain_ir_sensor_init();

   /* Init the WheelD. */
   QK_UtlWheelD_init(&Glb_AppMain.wheelD,
                     APP_WHEEL_LEFT_FORWARD_PIN,
                     APP_WHEEL_LEFT_BACKWARD_PIN,
                     APP_WHEEL_RIGHT_FORWARD_PIN,
                     APP_WHEEL_RIGHT_BACKWARD_PIN);

   /* Start application. */
   QK_UtlMmi_init(&Glb_AppMain.mmi,
                  (QK_CB_Handler)QK_AppMain_mmi_cmd_cb_handler,
                  CBnull, CBnull);
   QK_UtlMmi_exec_cmdstr_P(&Glb_AppMain.mmi, "h");
   QK_UtlMmi_prompt(&Glb_AppMain.mmi);
   QK_UtlMmi_enable(&Glb_AppMain.mmi, QK_MMI_POLL_TMRVAL_MSEC);

   /* Initialize with the default value. */
   Glb_AppMain.state = APP_ROBOT_ST_OFF;
   Glb_AppMain.ir_cal_val_track_min = APP_IR_CAL_VAL_TRACK_MIN;
   Glb_AppMain.ir_cal_val_track_max = APP_IR_CAL_VAL_TRACK_MAX;

   ir_sensor_auto_calibrate();
}

void loop()
{
   /*------------------------- LOCAL VARIABLES -------------------------------*/ 
   int  sample_left_2;
   int  sample_left_1;
   int  sample_center;
   int  sample_right_1;
   int  sample_right_2;

   /*------------------------------ CODE -------------------------------------*/
   switch (Glb_AppMain.state)
   {
      case APP_ROBOT_ST_OFF:
          break;

      case APP_ROBOT_ST_IDLE:
         delay(5000);     /* Time to prepare robot. */
         Glb_AppMain.state = APP_ROBOT_ST_STRAIGHT_START_FORWARD;
         break;

      case APP_ROBOT_ST_STRAIGHT_START_FORWARD:
         QK_printf("STRAIGHT_START_FORWARD\n");

         QK_UtlWheelD_control(&Glb_AppMain.wheelD,
                              QK_WHEELD_CTRL_GO_FORWARD,
                              QK_WHEELD_CTRL_OPT_NO_WAIT,
                              0, 0);
         Glb_AppMain.state = APP_ROBOT_ST_STRAIGHT_GOING_FORWARD;
         break;

      case APP_ROBOT_ST_STRAIGHT_GOING_FORWARD:
         sample_left_2  = QK_AppMain_ir_sensor_left_2(); 
         sample_left_1  = QK_AppMain_ir_sensor_left_1(); 
         sample_center  = QK_AppMain_ir_sensor_center(); 
         sample_right_1 = QK_AppMain_ir_sensor_right_1();
         sample_right_2 = QK_AppMain_ir_sensor_right_2();
         
         if (!is_on_track(sample_center))
         { 
            /* Going off the track. 
             * Active recovery. */
            Glb_AppMain.state = APP_ROBOT_ST_STRAIGHT_START_RECOVERY;
            break;
         }
         break;

      case APP_ROBOT_ST_STRAIGHT_START_RECOVERY:
         sample_left_2  = QK_AppMain_ir_sensor_left_2(); 
         sample_left_1  = QK_AppMain_ir_sensor_left_1(); 
         sample_center  = QK_AppMain_ir_sensor_center(); 
         sample_right_1 = QK_AppMain_ir_sensor_right_1();
         sample_right_2 = QK_AppMain_ir_sensor_right_2();
         
         QK_printf("START_RECOVERY, %d, %d, %d, %d, %d\n",
                   sample_left_2, sample_left_1,
                   sample_center, 
                   sample_right_1, sample_right_2);

         if (is_on_track(sample_left_1))
         { 
            /* Went off the right side of the track.
             * Need to turn left to get back on track. */
            Glb_AppMain.state = APP_ROBOT_ST_STRAIGHT_RECOVERY_START_LEFT;
            break;
         }

         if (is_on_track(sample_center))
         { 
            /* Went off the left side of the track.
             * Need to turn tight to get back on track. */
            Glb_AppMain.state = APP_ROBOT_ST_STRAIGHT_RECOVERY_START_RIGHT;
            break;
         }

         Glb_AppMain.state = APP_ROBOT_ST_PANIC; 
         break;

     case APP_ROBOT_ST_STRAIGHT_RECOVERY_START_LEFT:
         QK_printf("STRAIGHT_RECOVERY_START_LEFT\n");

         QK_UtlWheelD_control(&Glb_AppMain.wheelD,
                              QK_WHEELD_CTRL_TURN_LEFT,
                              QK_WHEELD_CTRL_OPT_NO_WAIT,
                              0, 0);
         Glb_AppMain.state = APP_ROBOT_ST_STRAIGHT_RECOVERY_GOING_LEFT;
         break;

      case APP_ROBOT_ST_STRAIGHT_RECOVERY_GOING_LEFT:
         sample_left_2  = QK_AppMain_ir_sensor_left_2(); 
         sample_left_1  = QK_AppMain_ir_sensor_left_1(); 
         sample_center  = QK_AppMain_ir_sensor_center(); 
         sample_right_1 = QK_AppMain_ir_sensor_right_1();
         sample_right_2 = QK_AppMain_ir_sensor_right_2();

         if (is_on_track(sample_center))
         {
            Glb_AppMain.state = APP_ROBOT_ST_STRAIGHT_START_FORWARD;
         }
         break;

     case APP_ROBOT_ST_STRAIGHT_RECOVERY_START_RIGHT:
         QK_printf("STRAIGHT_RECOVERY_START_RIGHT\n");

         QK_UtlWheelD_control(&Glb_AppMain.wheelD,
                              QK_WHEELD_CTRL_TURN_RIGHT,
                              QK_WHEELD_CTRL_OPT_NO_WAIT,
                              0, 0);
         Glb_AppMain.state = APP_ROBOT_ST_STRAIGHT_RECOVERY_GOING_RIGHT;
         break;

      case APP_ROBOT_ST_STRAIGHT_RECOVERY_GOING_RIGHT:
         sample_left_2  = QK_AppMain_ir_sensor_left_2(); 
         sample_left_1  = QK_AppMain_ir_sensor_left_1(); 
         sample_center  = QK_AppMain_ir_sensor_center(); 
         sample_right_1 = QK_AppMain_ir_sensor_right_1();
         sample_right_2 = QK_AppMain_ir_sensor_right_2();

         if (is_on_track(sample_center))
         {
            Glb_AppMain.state = APP_ROBOT_ST_STRAIGHT_START_FORWARD;
         }
         break;

      case APP_ROBOT_ST_PANIC:
         sample_left_2  = QK_AppMain_ir_sensor_left_2(); 
         sample_left_1  = QK_AppMain_ir_sensor_left_1(); 
         sample_center  = QK_AppMain_ir_sensor_center(); 
         sample_right_1 = QK_AppMain_ir_sensor_right_1();
         sample_right_2 = QK_AppMain_ir_sensor_right_2();

         QK_printf("PANIC, %d, %d, %d, %d, %d\n",
                   sample_left_2, sample_left_1, 
                   sample_center, 
                   sample_right_1, sample_right_2);

         QK_UtlWheelD_control(&Glb_AppMain.wheelD,
                              QK_WHEELD_CTRL_STOP,
                              QK_WHEELD_CTRL_OPT_NO_WAIT,
                              0, 0);

         Glb_AppMain.state = APP_ROBOT_ST_OFF;
         break;
   }
}

Bool is_on_track(int sample)
{
   /*------------------------- LOCAL VARIABLES -------------------------------*/ 
   /*------------------------------ CODE -------------------------------------*/
   if ((sample >= Glb_AppMain.ir_cal_val_track_min) &&
       (sample <= Glb_AppMain.ir_cal_val_track_max))
   {
      return(QK_TRUE);
   }
   else
   {
      return(QK_FALSE);
   }
}

void ir_sensor_auto_calibrate(void)
{
   /*------------------------- LOCAL VARIABLES -------------------------------*/ 
   /*------------------------------ CODE -------------------------------------*/
   Glb_AppMain.ir_cal_val_track_min = APP_IR_CAL_VAL_TRACK_MIN;
   Glb_AppMain.ir_cal_val_track_max = APP_IR_CAL_VAL_TRACK_MAX;
}


void QK_AppMain_mmi_help(void)
{
   /*------------------------- LOCAL VARIABLES -------------------------------*/
   /*------------------------------ CODE -------------------------------------*/
   QK_printf("\n");
   QK_printf(APP_MAIN_MMI_HELP_TITLE);
   QK_printf("========\n");
   QK_printf("h          = Menu\n");
   QK_printf("q <ctrl>   = Menu\n");
   QK_printf("   ctrl: 0 = off, 1 = on\n");
   QK_printf("s <repeat> = Sample IR sensor\n");
   QK_printf("l <ctrl>   = Left motor ctrl\n");
   QK_printf("   ctrl: %d = stop, %d = forward, %d = backward\n",
             QK_WHEELS_CTRL_STOP, QK_WHEELS_CTRL_GO_FORWARD, QK_WHEELS_CTRL_GO_BACKWARD);
   QK_printf("r <ctrl>   = Right motor ctrl\n");
   QK_printf("   ctrl: %d = stop, %d = forward, %d = backward\n",
             QK_WHEELS_CTRL_STOP, QK_WHEELS_CTRL_GO_FORWARD, QK_WHEELS_CTRL_GO_BACKWARD);
   QK_printf("w <ctrl> <tmo> <speed> = Wheel movement ctrl\n");
   QK_printf("   ctrl: %d = stop\n",
             QK_WHEELD_CTRL_STOP);
   QK_printf("         %d = forward, %d = backward\n",
             QK_WHEELD_CTRL_GO_FORWARD, QK_WHEELD_CTRL_GO_BACKWARD);
   QK_printf("         %d = left,    %d = right\n",
             QK_WHEELD_CTRL_TURN_LEFT, QK_WHEELD_CTRL_TURN_RIGHT);
   QK_printf("\n");
}

int QK_AppMain_mmi_cmd_cb_handler(CBarg cb_mmi,
                                  CBarg cb_cmdbuf,
                                  CBarg arg2,
                                  CBarg arg3)
{
   /*------------------------- LOCAL VARIABLES -------------------------------*/
   int    retVal = QK_CB_HANDLER_RETVAL_CONSUMED;
   char  *cmd_ptr = (char *)cb_cmdbuf;
   char   option[10];
   Slong  ctrl;
   int    i;
   int    sample_left_2;
   int    sample_left_1;
   int    sample_center;
   int    sample_right_1;
   int    sample_right_2;
   Slong  timeout;
   Slong  speed;

   /*------------------------------ CODE -------------------------------------*/
   cmd_ptr = QK_UtlMisc_strcpy_word(cmd_ptr,
                                    option,
                                    sizeof(option));

   switch (option[0])
   {
      case 'h':
         QK_AppMain_mmi_help();
         break;

      case 'q':
         cmd_ptr = QK_UtlMisc_str2num(cmd_ptr, &ctrl);
         if (cmd_ptr == NULL)
         {
            QK_printf("Bad cmd: Missing arguments.\n");
            QK_AppMain_mmi_help();
            break;
         }

         if (ctrl == 0)
         { 
            QK_printf("Turn robot off.\n");
            
            QK_UtlWheelD_control(&Glb_AppMain.wheelD,
                                 QK_WHEELD_CTRL_STOP,
                                 QK_WHEELD_CTRL_OPT_NO_WAIT,
                                 0, 0);
            Glb_AppMain.state = APP_ROBOT_ST_OFF;
         }
         else 
         {
            QK_printf("Turn robot on.\n");
            Glb_AppMain.state = APP_ROBOT_ST_STRAIGHT_START_FORWARD;
         }
         break;

      case 's':
         cmd_ptr = QK_UtlMisc_str2num(cmd_ptr, &ctrl);
         if (cmd_ptr == NULL)
         {
            QK_printf("Bad cmd: Missing arguments.\n");
            QK_AppMain_mmi_help();
            break;
         }

         for (i = 0; i < (int)ctrl; i++)
         {
            sample_left_2   = QK_AppMain_ir_sensor_left_2(); 
            sample_left_1   = QK_AppMain_ir_sensor_left_1(); 
            sample_center   = QK_AppMain_ir_sensor_center(); 
            sample_right_1  = QK_AppMain_ir_sensor_right_1();
            sample_right_2  = QK_AppMain_ir_sensor_right_2(); 
            
            QK_printf("Sample #%d: %d, %d, %d, %d, %d\n",
                       i + 1, 
                       sample_left_2, sample_left_1, 
                       sample_center, 
                       sample_right_1, sample_right_2);
         }
         
         QK_printf("Done.\n");
         break;

      case 'l':
         cmd_ptr = QK_UtlMisc_str2num(cmd_ptr, &ctrl);
         if (cmd_ptr == NULL)
         {
            QK_printf("Bad cmd: Missing arguments.\n");
            QK_AppMain_mmi_help();
            break;
         }

         if ((ctrl != QK_WHEELS_CTRL_STOP)       &&
             (ctrl != QK_WHEELS_CTRL_GO_FORWARD) &&
             (ctrl != QK_WHEELS_CTRL_GO_BACKWARD))
         {
            QK_printf("Bad cmd: Bad arguments.\n");
            break;
         }

         QK_UtlWheelS_control(&Glb_AppMain.wheelD.wheelLeft,
                              (int)ctrl);
         break;

      case 'r':
         cmd_ptr = QK_UtlMisc_str2num(cmd_ptr, &ctrl);
         if (cmd_ptr == NULL)
         {
            QK_printf("Bad cmd: Missing arguments.\n");
            QK_AppMain_mmi_help();
            break;
         }
         
         if ((ctrl != QK_WHEELS_CTRL_STOP)       &&
             (ctrl != QK_WHEELS_CTRL_GO_FORWARD) &&
             (ctrl != QK_WHEELS_CTRL_GO_BACKWARD))
         {
            QK_printf("Bad cmd: Bad arguments.\n");
            break;
         }

         QK_UtlWheelS_control(&Glb_AppMain.wheelD.wheelRight,
                              (int)ctrl);
         break;

      case 'w':
         cmd_ptr = QK_UtlMisc_str2num(cmd_ptr, &ctrl);
         if (cmd_ptr == NULL)
         {
            QK_printf("Bad cmd: Missing arguments.\n");
            QK_AppMain_mmi_help();
            break;
         }
         
         if ((ctrl != QK_WHEELD_CTRL_STOP)        &&
             (ctrl != QK_WHEELD_CTRL_GO_FORWARD)  &&
             (ctrl != QK_WHEELD_CTRL_GO_BACKWARD) &&
             (ctrl != QK_WHEELD_CTRL_TURN_LEFT)   &&
             (ctrl != QK_WHEELD_CTRL_TURN_RIGHT))
         {
            QK_printf("Bad cmd: Bad arguments.\n");
            break;
         }

         cmd_ptr = QK_UtlMisc_str2num(cmd_ptr, &timeout);
         if (cmd_ptr == NULL)
         {
            timeout = 0;
         }

         cmd_ptr = QK_UtlMisc_str2num(cmd_ptr, &speed);
         if (cmd_ptr == NULL)
         {
            speed = 0;
         }

         QK_UtlWheelD_control(&Glb_AppMain.wheelD,
                              (int)ctrl,
                              QK_WHEELD_CTRL_OPT_NO_WAIT,
                              (Ulong)timeout,
                              (Ulong)speed);
         break;

      case '\0':
         /* No command entered. */
         break;

      default:
         /* Unknown command. */
         QK_printf("Unknown cmd: %s\n", option);
         QK_AppMain_mmi_help();
         break;
   }

   return(retVal);
}

void QK_AppMain_ir_sensor_init(void)
{
   /*------------------------- LOCAL VARIABLES -------------------------------*/ 
   /*------------------------------ CODE -------------------------------------*/
   pinMode(APP_IR_TRANSMITTER_LEFT_2, OUTPUT);
   pinMode(APP_IR_RECEIVER_LEFT_2,INPUT);

   pinMode(APP_IR_TRANSMITTER_LEFT_1, OUTPUT);
   pinMode(APP_IR_RECEIVER_LEFT_1,INPUT);

   pinMode(APP_IR_TRANSMITTER_CENTER, OUTPUT);
   pinMode(APP_IR_RECEIVER_CENTER,INPUT);

   pinMode(APP_IR_TRANSMITTER_RIGHT_1, OUTPUT);
   pinMode(APP_IR_RECEIVER_RIGHT_1,INPUT);

   pinMode(APP_IR_TRANSMITTER_RIGHT_2, OUTPUT);
   pinMode(APP_IR_RECEIVER_RIGHT_2,INPUT);

   /* Turn off the transmitter. */
   digitalWrite(APP_IR_TRANSMITTER_LEFT_2, LOW);
   digitalWrite(APP_IR_TRANSMITTER_LEFT_1, LOW);
   digitalWrite(APP_IR_TRANSMITTER_CENTER, LOW);
   digitalWrite(APP_IR_TRANSMITTER_RIGHT_1, LOW);
   digitalWrite(APP_IR_TRANSMITTER_RIGHT_2, LOW);
}

int QK_AppMain_ir_sensor_left_2(void)
{
   /*------------------------- LOCAL VARIABLES -------------------------------*/ 
   int sample;
   int sample_max = 0;
   int i;

   /*------------------------------ CODE -------------------------------------*/
   for (i = 0; i < APP_IR_CAL_NUM_SAMPLES_MAX; i++)
   {
      /* Turn on the transmitter. */
      digitalWrite(APP_IR_TRANSMITTER_LEFT_2, HIGH);
   
      /* Sample the receiver. */
      sample = analogRead(APP_IR_RECEIVER_LEFT_2); 

      /* Turn off the transmitter. */
      digitalWrite(APP_IR_TRANSMITTER_LEFT_2, LOW);

      if (sample > sample_max)
      {
         sample_max = sample;
      }
   }
   
   return(sample_max);
}

int QK_AppMain_ir_sensor_left_1(void)
{
   /*------------------------- LOCAL VARIABLES -------------------------------*/ 
   int sample;
   int sample_max = 0;
   int i;

   /*------------------------------ CODE -------------------------------------*/
   for (i = 0; i < APP_IR_CAL_NUM_SAMPLES_MAX; i++)
   {
      /* Turn on the transmitter. */
      digitalWrite(APP_IR_TRANSMITTER_LEFT_1, HIGH);
   
      /* Sample the receiver. */
      sample = analogRead(APP_IR_RECEIVER_LEFT_1); 

      /* Turn off the transmitter. */
      digitalWrite(APP_IR_TRANSMITTER_LEFT_1, LOW);

      if (sample > sample_max)
      {
         sample_max = sample;
      }
   }
   
   return(sample_max);
}

int QK_AppMain_ir_sensor_center(void)
{
   /*------------------------- LOCAL VARIABLES -------------------------------*/ 
   int sample;
   int sample_max = 0;
   int i;

   /*------------------------------ CODE -------------------------------------*/
   for (i = 0; i < APP_IR_CAL_NUM_SAMPLES_MAX; i++)
   {
      /* Turn on the transmitter. */
      digitalWrite(APP_IR_TRANSMITTER_CENTER, HIGH);
   
      /* Sample the receiver. */
      sample = analogRead(APP_IR_RECEIVER_CENTER); 

      /* Turn off the transmitter. */
      digitalWrite(APP_IR_TRANSMITTER_CENTER, LOW);

      if (sample > sample_max)
      {
         sample_max = sample;
      }
   }
   
   return(sample_max);
}

int QK_AppMain_ir_sensor_right_1(void)
{
   /*------------------------- LOCAL VARIABLES -------------------------------*/ 
   int sample;
   int sample_max = 0;
   int i;

   /*------------------------------ CODE -------------------------------------*/
   for (i = 0; i < APP_IR_CAL_NUM_SAMPLES_MAX; i++)
   {
      /* Turn on the transmitter. */
      digitalWrite(APP_IR_TRANSMITTER_RIGHT_1, HIGH);
   
      /* Sample the receiver. */
      sample = analogRead(APP_IR_RECEIVER_RIGHT_1); 

      /* Turn off the transmitter. */
      digitalWrite(APP_IR_TRANSMITTER_RIGHT_1, LOW);

      if (sample > sample_max)
      {
         sample_max = sample;
      }
   }
   
   return(sample_max);
}

int QK_AppMain_ir_sensor_right_2(void)
{
   /*------------------------- LOCAL VARIABLES -------------------------------*/ 
   int sample;
   int sample_max = 0;
   int i;

   /*------------------------------ CODE -------------------------------------*/
   for (i = 0; i < APP_IR_CAL_NUM_SAMPLES_MAX; i++)
   {
      /* Turn on the transmitter. */
      digitalWrite(APP_IR_TRANSMITTER_RIGHT_2, HIGH);
   
      /* Sample the receiver. */
      sample = analogRead(APP_IR_RECEIVER_RIGHT_2); 

      /* Turn off the transmitter. */
      digitalWrite(APP_IR_TRANSMITTER_RIGHT_2, LOW);

      if (sample > sample_max)
      {
         sample_max = sample;
      }
   }
   
   return(sample_max);
}
