# dircmp

dircmp is a utility modules which allows comparison of directories by creating
hash unique to the files and links contained and their locations.

## Install

```sh
npm install dircmp
```

## Quick Examples

```javascript
// comparison
dircmp.cmp('/home/betty', '/home/bill', function(err, areEqual) {
  if (areEqual) {
    console.log('Wow - very compatible');
  } else {
    console.log('Opposites attract?');
  };
});

// hash
dircmp.hash('/home/chuck', function(err, digest) {
  console.log('hex digest: ' + digest);
});
```

## Test

```sh
git clone https://github.com/jdubie/dircmp.git
cd dircmp
npm install
make test
```
