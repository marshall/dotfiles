Components.utils.import("resource://gre/modules/Services.jsm");

let versions = arguments;
let test_versions = [
  "1.0", "1.0.0", "1.0.0beta", "1.0.0.1", "1.0.20", "1.0.2.0", "1.1.0.1",
  "1.1.0", "1.1.0alpha"
];

versions.sort(Services.vc.compare);
versions.reverse();

for (let i = 0; i < versions.length; i++) {
  if (i == 0) {
    print(versions[i]);
    continue;
  }

  print(" > " + versions[i]);
}
