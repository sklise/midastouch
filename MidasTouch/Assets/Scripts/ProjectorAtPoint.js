// Apply this script to every object to turn gold.
// On collision, spawns a projector looking at the point.
// The Projector applies the specified material to _only_
// this object.

public var projectorMaterial : Material;

function Start () {

}

function Update () {

}

function OnCollisionEnter (collision : Collision) {
  Debug.Log(collision.contacts.length);

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
  var projectorWrapper = new GameObject();
  // Set projectorWrapper as a child of this object
  projectorWrapper.transform.parent = transform;
  // And give it the same position as this object
  projectorWrapper.transform.position = contactAverage + normalAverage * -1.5;
  // Create a projector and attach it to the projectorWrapper
  var proj : Projector;
  proj = projectorWrapper.AddComponent ("Projector");
  proj.material = projectorMaterial;
  // Ignore the default & water layers.
  // You must move this object into a different layer for the shadow to show.
  proj.ignoreLayers = (1<<4)+(1<<0);
  projectorWrapper.transform.LookAt(contactAverage);
}

function OnCollisionStay (collision : Collision) {
  
}

function OnCollisionExit (collision : Collision) {
  
}