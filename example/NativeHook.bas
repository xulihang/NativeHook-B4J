B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.9
@EndOfDesignText@
Sub Class_Globals
	Private globalScreen As JavaObject
	Private mCallBack As Object 'ignore
	Private mEventName As String 'ignore
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
	globalScreen.InitializeStatic("com.github.kwhat.jnativehook.GlobalScreen")
	globalScreen.RunMethod("registerNativeHook",Null)
	Dim example As JavaObject
	Dim jo As JavaObject = Me
	example = jo.RunMethod("newInstance",Null)
	globalScreen.RunMethod("addNativeKeyListener",Array(example))
End Sub

Public Sub unregister
	globalScreen.RunMethod("unregisterNativeHook",Null)
End Sub

Private Sub getKeyText(e As JavaObject) As String
	Return e.RunMethod("getKeyText",Array(e.RunMethod("getKeyCode",Null)))
End Sub

private Sub nativeKeyPressed(e As Object)
	CallSubDelayed2(mCallBack,mEventName&"_NativeKeyPressed",getKeyText(e))
End Sub

private Sub nativeKeyTyped(e As Object)
	CallSubDelayed2(mCallBack,mEventName&"_NativeKeyTyped",getKeyText(e))
End Sub

private Sub nativeKeyReleased(e As Object)
	CallSubDelayed2(mCallBack,mEventName&"_NativeKeyReleased",getKeyText(e))
End Sub

#If Java
import com.github.kwhat.jnativehook.NativeHookException;
import com.github.kwhat.jnativehook.keyboard.NativeKeyEvent;
import com.github.kwhat.jnativehook.keyboard.NativeKeyListener;

public GlobalKeyListenerExample newInstance(){
    return new GlobalKeyListenerExample();
}

public class GlobalKeyListenerExample implements NativeKeyListener {
	public void nativeKeyPressed(NativeKeyEvent e) {
		if (ba.subExists("nativekeypressed")) {
	        ba.raiseEvent2(null, true, "nativekeypressed", false, e);
	    }
	}

	public void nativeKeyReleased(NativeKeyEvent e) {
		if (ba.subExists("nativekeyreleased")) {
	        ba.raiseEvent2(null, true, "nativekeyreleased", false, e);
	    }
	}

	public void nativeKeyTyped(NativeKeyEvent e) {
		//System.out.println("Key Typed: " + e.getKeyText(e.getKeyCode()));
		if (ba.subExists("nativekeytyped")) {
	        ba.raiseEvent2(null, true, "nativekeytyped", false, e);
	    }
	}
}
#End If