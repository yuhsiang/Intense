using UnityEngine;
using System.Collections;

public class score : MonoBehaviour {
	
	void OnCollisionEnter(Collision collision ) {
		if (collision.gameObject.name.CompareTo("WarpZone_Obj_Dart")==0){
			 Destroy(this);
		} else {
			Debug.LogWarning("no");
		}
		
		
	}
}
