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
	private const int SPEED_FACTOR = 200;
	void FixedUpdate(){
		if (hasAppliedForce){
			this.transform.Translate(direction * force/SPEED_FACTOR,  Space.World);
		}
	}
		
	void Update(){
		if (Input.GetMouseButtonDown(0) &&!hasAppliedForce){
		
			mouseDownPosition = new Vector3(Input.mousePosition.x
			                                ,Input.mousePosition.y, transform.position.z);
			
   		
		} else if (Input.GetMouseButtonUp(0)&&!hasAppliedForce){
			mouseUpPosition = new Vector3(Input.mousePosition.x
			                                ,Input.mousePosition.y, transform.position.z);
			direction = Vector3.up*(mouseUpPosition.y-mouseDownPosition.y)+ Vector3.right*(mouseUpPosition.x-mouseDownPosition.x);
			force = direction.magnitude;	
			transform.LookAt(new Vector3(-direction.x
			                                ,-direction.y, transform.position.z));
			direction.Normalize();
			this.transform.Translate(direction * force/SPEED_FACTOR,  Space.World);	
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
