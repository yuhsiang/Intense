using UnityEngine;
using System.Collections;

public class DartMovement : MonoBehaviour {
	public GameObject dart;
	public Transform PopEffect;
	private Vector3 mouseDownPosition;
	private Vector3 mouseUpPosition;
	private bool hasAppliedForce = false;
	private Vector3 direction;
	private float force ;
	
	void FixedUpdate(){
		if (hasAppliedForce){
					this.transform.Translate(direction * force/130,  Space.World);
		}
	}
		
	void Update(){
		if (Input.GetMouseButtonDown(0) &&!hasAppliedForce){
			//Vector3 position = (new Vector3(Input.mousePosition.x, Input.GetAxis("Mouse Y"), dart.transform.position.z));
			
			mouseDownPosition = new Vector3(Input.mousePosition.x
			                                ,Input.mousePosition.y, transform.position.z);
			
			
			
   			//this.transform.Translate(Vector3.up * Input.GetAxis("Mouse Y")+Vector3.right*Input.GetAxis("Mouse X"),  Space.World);
		} else if (Input.GetMouseButtonUp(0)&&!hasAppliedForce){
	
			mouseUpPosition = new Vector3(Input.mousePosition.x
			                                ,Input.mousePosition.y, transform.position.z);
			direction = Vector3.up*(mouseUpPosition.y-mouseDownPosition.y)+ Vector3.right*(mouseUpPosition.x-mouseDownPosition.x);
			force = direction.magnitude;
			
			direction.Normalize();
			
			this.transform.Translate(direction * force/130,  Space.World);
			
			this.transform.Rotate(direction.x, direction.y, 0);
			hasAppliedForce = true;
			
		}	
	}
	
	
	void OnCollisionEnter(Collision collision ) {
		if (collision.gameObject.name.CompareTo("Sphere")==0){
			 Destroy(collision.gameObject);
			
			// Quaternion.identity -> The identity rotation (Read Only). This quaternion corresponds to "no rotation": the object
			//
			Instantiate(PopEffect, collision.transform.position,  Quaternion.identity);
			
			
			
			
		} else {
			//Debug.LogWarning("no");
		}
		
		
	}
	
	
	
}
