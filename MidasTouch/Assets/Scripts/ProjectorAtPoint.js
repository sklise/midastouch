// Apply this script to every object to turn gold.
// On collision, spawns a projector looking at the point.
// The Projector applies the specified material to _only_
// this object.

public var projectorMaterial : Material;
public var water : GameObject;

function Start () {

}

function Update () {
 if(transform.childCount >= 1) {
   proj = transform.Find("projectorWrapper");
   p = proj.GetComponent("Projector");
   p.nearClipPlane = Mathf.Clamp(p.nearClipPlane - Time.deltaTime * 0.5, 0.1, 10.0);
   p.farClipPlane = Mathf.Clamp(p.farClipPlane + Time.deltaTime * 0.53, 0.1, 500.0);
 }
}
function OnCollisionEnter (collision : Collision) {
  Debug.Log(collision.contacts.length);
  x = water.GetComponent("rippleSharp");
  x.splashCenter();
  // Debug-draw all contact points and normals
  var contactSum : Vector3 = Vector3.zero;
  var normalSum : Vector3 = Vector3.zero;
  for (var contact : ContactPoint in collision.contacts) {
    Debug.DrawRay(contact.point, contact.normal, Color.white);
    contactSum = contactSum + contact.point;
    normalSum = normalSum + contact.normal;
  }

  var contactAverage = contactSum * (1.0 / collision.contacts.length);
  var normalAverage = normalSum * (1.0 / collision.contacts.length);

  // Make an empty gameObject to hold the Projectpr
  // Set projectorWrapper as a child of this object
  if(transform.childCount == 0) {
  	var projectorWrapper = new GameObject();
  	projectorWrapper.transform.parent = transform;
  	projectorWrapper.name = "projectorWrapper"; 
  // And give it the same position as this object
  projectorWrapper.transform.position = contactAverage + normalAverage * -7;
  // Create a projector and attach it to the projectorWrapper
  var proj : Projector;
  proj = projectorWrapper.AddComponent("Projector");
  proj.material = projectorMaterial;
  proj.orthographic = true;
  // Ignore the default & water layers.
  // You must move this object into a different layer for the shadow to show.
  proj.ignoreLayers = (1<<4)+(1<<0);
  projectorWrapper.transform.LookAt(contactAverage);
	proj.nearClipPlane = (normalAverage * 7.0).magnitude;
    proj.farClipPlane = (normalAverage * 7.0).magnitude;
	}	
}
function OnCollisionStay (collision : Collision) {
  
}

function OnCollisionExit (collision : Collision) {
  
}