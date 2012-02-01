using UnityEngine;
using System.Collections;

public class DartMovement : MonoBehaviour {
	public GameObject dart;
	public Transform PopEffect;
	private Vector3 mouseDownPosition;
	private Vector3 mouseUpPosition;

	
	// Update is called once per frame
	void Update () {
		if (Input.GetMouseButton(0)){
			//Vector3 position = (new Vector3(Input.mousePosition.x, Input.GetAxis("Mouse Y"), dart.transform.position.z));
			
			mouseDownPosition = new Vector3(Input.GetAxis("Mouse X") 
			                                ,Input.GetAxis("Mouse Y"), transform.position.z);
			Debug.LogWarning(mouseDownPosition.x + ", "+mouseDownPosition.y);
			
   			//this.transform.Translate(Vector3.up * Input.GetAxis("Mouse Y")+Vector3.right*Input.GetAxis("Mouse X"),  Space.World);
		} else if (Input.GetMouseButtonUp(0)){
			mouseUpPosition = new Vector3(Input.GetAxis("Mouse X") 
			                                ,Input.GetAxis("Mouse Y"), transform.position.z);
			Vector3 force = new Vector3(mouseDownPosition.x-mouseUpPosition.x, mouseDownPosition.y-mouseUpPosition.y, mouseDownPosition.z);
			rigidbody.AddForce(force*10);
			Debug.LogWarning("mouseDown");
			
		}
	}
	
	void OnCollisionEnter(Collision collision ) {
		if (collision.gameObject.name.CompareTo("Sphere")==0){
			 Destroy(collision.gameObject);
			
			// Quaternion.identity -> The identity rotation (Read Only). This quaternion corresponds to "no rotation": the object
			//
			Instantiate(PopEffect, collision.transform.position,  Quaternion.identity);
			
			
			
			
		} else {
			Debug.LogWarning("no");
		}
		
		
	}
	
	
	
}
