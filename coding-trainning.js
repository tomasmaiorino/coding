//
// first duplicate value
//
const input = [2,1,5,2,3,3,4];
// v1 using a map to store each value, then check whether map contains the element
// v2 could use an inner loop, store the index position of the latest element, the return should be the item with the smallest index
const firstDuplicateValue = (input) => {
  let store = new Set();
  let response = 0;
  input.forEach(element => {
    if(store.has(element)) {
      response = element;
      break;
    } else {
      store.add(element);
    }
  });
  return response;
}
//
// arrayOfProducts
//
const input = [];
const arrayOfProducts = (input) => {
  let result = [];
  let tmp = 0;
  for (let index = 0; index < input.length; index++) {
    tmp = tmp * input[index];
  }
  for (let index = 0; index < input.length; index++) {
    result.push(tmp /  input[index]);
  }
  return result;
}
//
// longest peak
//
//v3
const longestPeak = (input) => {
  let peak = 0;
  for(let i = 1; i < input.length - 1; i++) {
      // it is a peak
      if (input[i - 1] < input[i] && input[i] > input[i + 1]) {
          let countPeak = 3;
          let countTmp = i - 1;
          while(countTmp > 0 && input[countTmp] > input[countTmp - 1]) {
              countPeak++;
              countTmp--;
          }
          countTmp = i + 1;
          while(countTmp < input.length - 1 && input[countTmp] > input[countTmp + 1]) {
              countPeak++;
              countTmp++
          } 
          if(countPeak > peak) {
              peak = countPeak;
          }
          i = countPeak;
      }
  }
  return peak;
}
console.log(longestPeak(input));
//v2
let input = [1,2,3,3,4,0,10,6,5,-1,-3,2,3];
const longestPeak = (input) => {
  let peak = [];
  for(let k = 0; k < input.length;) {
    let tmpPeak = [input[k]];
    while(input[k] <= input[k + 1]) {
      tmpPeak.push(input[k + 1]);
      k++;
    }
    while(input[k] >= input[k + 1] && tmpPeak.length > 1) {
      tmpPeak.push(input[k + 1]);
      k++;
    }
    if (tmpPeak.length == 1) {
      k++;
    }
   if (tmpPeak.length > peak.length && !hasOnlyGrow) {
      peak = tmpPeak;
    }
  }
  return peak.length;
}
//v1
const longestPeak = (input) => {
  let peak = [];
  for(let i = 0; i < input.length - 2;) {
    //check whether the next item is greather than the current one, if true, start checking the peak    
    let peakStart = i;
    let hasOnlyGrow = true;
    let tempPeak = [input[peakStart]];
    while (input[peakStart] < input[peakStart + 1]) {
      //
      tempPeak.push(input[peakStart + 1]);
      peakStart++;
    }
    while (input[peakStart] > input[peakStart + 1] && tempPeak.length > 0) {
      //      
      tempPeak.push(input[peakStart + 1]);
      peakStart++;
      hasOnlyGrow = false;
    }
    if (tempPeak.length > peak.length && !hasOnlyGrow) {
      peak = tempPeak;
    }
    i++;
  }
  console.log(peak);
  return peak.length;
}return peak.length;
}
//
// Spiral Traverse
//
//let input = [[1,2,3,4], [12,13,14,5], [11,16,15,6], [10,9,8,7]];
let input = [[1,2,3,4,6], [11,10,9,8,7]];
const spiralTravers = (input) => {
  let startX = 0;
  let endX = input[0].length;
  let startY = 0;
  let endY = input.length;
  let response = [];
  while(response.length < input.length * input[0].length) {
  //  console.log('y x ', startY, startX)
    for(let i = startX; i < endX - 1; i++) {
      response.push(input[startY][i]);
    }
  //  console.log('response ', response)
    for(let i = startY; i < endY - 1; i++) {
  //    console.log('response ', response)
      response.push(input[i][endX - 1]);
    }
    for(let i = endX - 1; i > startX; i--) {
    //  console.log('response ', response)
      response.push(input[endY - 1][i]);
    }
    for(let i = endY - 1; i > startY; i--) {
      response.push(input[i][startX]);
    }
    startX += 1;
    startY += 1;
    endX -= 1;
    endY -= 1;
  }
    return response;

}
//
//Monotonic array
//
//let input = [21,22,22,22,23,44,45,55,56,60,62];
let input = [210,200,199,180,66,55,44,32,31,30,30,29,28];
//v2
const monotonicArray = (input) => {
  
  let isUp = true;
  let isDown = true;

  for(let i = 0; i < input.length - 1; i++) {
      if (input[i] < input[i + 1]) {
        isUp = false;
      } else if (input[i] > input[i + 1]) {
        isDown = false;
      }
  }
  return isUp || isDown;
}
//v1
const monotonicArray = (input) => {
  
  let checkUp = null;

  for(let i = 0; i < input.length - 1; i++) {
      if (input[i] != input[i + 1]) {
        if (checkUp == null) {
          checkUp = input[i] < input[i + 1];
        } else if (checkUp && !(input[i] < input[i + 1])) {
          return false;
        } else if (!checkUp && (input[i] < input[i + 1])) {
          return false;
        }
      }
  }
  return true;
}
console.log(monotonicArray(input))

//
//Move element to end
//
let input = [2,1,2,2,2,3,4,2,23,3,4];
const moveElementToEnd = (array, key) => {
  let i = 0;
  let k = array.length - 1;
  while(i < array.length) {
    if(array[i] == key && k > i) {
      if (array[k] != key) {
        array[i] = array[k];
        array[k] = key;
        i++;
      }
      k--;
    } else {
      i++;
    }
  }
/*  
  let idx = array.length - 1;
  for(let i = 0; i < array.length; i++) {
      if(array[i] == key) {
        let lastValue = array[idx];
        while(idx > i) {
          if(lastValue == key) {
            lastValue = array[--idx];
          } else {
            array[idx] = key;
            array[i] = lastValue;
            break;
          }
        }
      }
  }
  */
  return array;
}
console.log(moveElementToEnd(input, 2));

//
//Smallest Difference
//
let inputA = [-1,5,10,20,28,3];
let inputB = [26,134,135,15,17,26,2];
const smallesDifference = (inputA, inputB) => {
  let difference = 100000;
  let response = [];

  inputA.sort((a, b) => {return a - b});
  inputB.sort((a, b) => {return a - b});

  let idxOne = 0;
  let idxTwo = 0;

  while (idxOne < inputA.length && idxTwo < inputB.length) {
    let tmp = Math.abs(inputA[idxOne] - inputB[idxTwo]);
    if (tmp < difference) {
      difference = tmp;
      response = [inputA[idxOne], inputB[idxTwo]];
    }
    if (inputA[idxOne] < inputB[idxTwo]) {
      idxOne++;
    } else if (inputA[idxOne] > inputB[idxTwo]) {
      idxTwo++;
    } else {
      return [inputA[idxOne], inputB[idxTwo]];
    }
  }

  return response;
}
console.log(smallesDifference(inputA, inputB));

//
// threeNumberSum
//
let input = [12,3,1,2,-6,5,-8,6];
const threeNumberSum = (input, target) => {
  input = input.sort((a, b) => a - b);
  let response = [];
  for (let i = 0; i < input.length; i++) {
    for (let k = i + 1, j = input.length - 1; k < j;) {
      let cs = input[i] + input[k] + input[j];
      if (cs == target) {
        let tmp = [];
        tmp.push(input[i])
        tmp.push(input[k])
        tmp.push(input[j])
        response.push(tmp)
        k++;
        j--
      } else if(cs > target) {
        j--
      } else {
        k++
      }
    }
  }
  return response;
}
console.log(threeNumberSum(input, 0));

//
// ceaser cipher
//
const cipher = (word, cod) => {
  cod = cod % 26;
  let response = [];
  for(let i = 0; i < word.length; i++) {
    response.push(getNewLetter(word.charAt(i), cod))
  }
  return response.join('')
}

const getNewLetter = (letter, cod) => {
  let number = letter.charCodeAt() + cod;
  //console.log('number ' + number)
  return String.fromCharCode(number > 122 ? 96 + number % 122 : number);
}

console.log(cipher('xyz', 54))

//
// Palindrome
//
let input = 'barafdarab'

const isPalindrome = (word, i) => {
  let end = word.length - 1 - i;
  if (i >= end) {
    return true;
  }

  return word[i] == word[end] && isPalindrome(word, i + 1);  
}

//console.log(isPalindrome(input.split(''), 0))

const isPalindrome2 = (word, i) => {

  for (let i = 0, k = word.length - 1; i < word.length / 2; i++, k--) {
    if (word[i] != word[k]) {
      return false;
    }
  }
 return true;
}
console.log(isPalindrome2(input.split('')))

//
// BUBLLE SORT
// LESSON 14
//
let input = [78,141, 1, 17, -7, -17, -27, 18, -123, 541, 8, 7, 7,-30,-332,222,-999,-888]

const selectionSort = (array) => {
  let currentIdx = 0;
  while (currentIdx < array.length - 1) {
     let sml = currentIdx;
    for (let k = currentIdx + 1; k < array.length; k++) {
      if (array[k] < array[sml]) {
        sml = k
      }
    }
    let tmp = array[currentIdx];
    array[currentIdx] = array[sml];
    array[sml] = tmp;
    currentIdx++;
  }
   
  return array;
}
console.log(selectionSort(input))

//
// BUBLLE SORT
// LESSON 12 (13)
//
let input = [141, 1, 17, -7, -17, -27, 18, -123, 541, 8, 7, 7,-30,-332,222,-999]

const bubbleSort = (array) => {
  let length = array.length;
  let isSorted = false;
  while(!isSorted) {
    isSorted = true;
    for (let index = 0; index < length - 1; index++) {
        let tmp = array[index];
        if(tmp > array[index + 1]) {
          array[index] = array[index + 1];
          array[index + 1] = tmp;
          isSorted = false;
        }
      }
    length--;
  }
  return array;
}
console.log(bubbleSort(input))

//
// INSERTION SORT
// LESSON 13 (12)
//
let input = [141, 1, 17, -7, -17, -27, 18, 541, 8, 7, 7,-30]

const insertionSort = (array) => {
  for (let i = 0; i < array.length - 1; i++) {
    for (let k = i + 1; k > 0 
         && array[k] < array[k - 1]; k--) {
        let tmp = array[k - 1];
        array[k - 1] = array[k]
        array[k] = tmp;
    }
  }
  return array;
}
console.log(insertionSort(input));
//console.log(findThreeLargest(input))
//
// FIND THREE HIGHER
// LESSON 11
//
const findThreeLargest2 = (array) => {
  let resp = [Number.MIN_VALUE, Number.MIN_VALUE, Number.MIN_VALUE];
  for (let i = 0; i < array.length; i++) {
    let tmp = array[i];
    if (tmp > resp[2]) {
      resp[0] = resp[1];
      resp[1] = resp[2];
      resp[2] = tmp
    } else if (tmp > resp[1]) {
      resp[0] = resp[1];
      resp[1] = tmp;
    } else if (tmp > resp[0]) {
      resp[0] = tmp;
    }
  }
  return resp;
}
let input = [141, 1, 17, -7, -17, -27, 18, 541, 8, 7, 7]
const findThreeLargest = (array) => {
  let hig = array[0];
  let mid = array[1];
  let low = array[2];
  for (let i = 1; i < array.length; i++) {
    let tmp = array[i];
    if (tmp > hig) {
      low = mid;
      mid = hig
      hig = tmp;
    } else if (tmp < hig) {
      if (tmp > mid) {
        low = mid;
        mid = tmp
      }
      if (tmp < mid && tmp > low) {
        low = tmp;
      }
    } else if (tmp == mid) {
      low = tmp;
    }
  }
  return [low, mid, hig];
}
//
// BINARY SEARCH
//
/*
const binarySearch = (array, element, start, end) => {

  if (start > end) {
    return -1;
  }

  let m = end - start / 2;

  if (element == array[m]) {
    return m;
  } else if (element > array[m]) {
    return binarySearch(array, element, m + 1, end);
  } else {
    return binarySearch(array, element, start, m - 1);
  }
}

const search = (array, element) => {
  if (element < array[0] || element > array[array.length - 1]) {
    return -1;
  }
  return binarySearch(array, element, 0, array.length - 1);
}
const search2 = (array, element) => {
  if (element < array[0] || element > array[array.length - 1]) {
   return -1;
 }
  let start = 0;
  let end = array.length;
  while(start < end) {
    let m = end - start / 2;
    if (element == array[m]) {
      return m;
    } else if (element > array[m]) {
      start = m + 1;
    } else {
      end = m - 1;
    }
  }
  return -1;
}
*/
//
// PRODUCT SUM
//
/*
let input = [2, 5, [7, -1], 3, [6, [-13, 8], 4] ];

const productSum = (array, multiplier) => {
  let sum = 0;
  let i = 0;
  for( i; i < array.length; i++) {
    if (isNaN(array[i])) {
      sum += productSum(array[i], multiplier + 1);
    } else {
      sum += array[i];
    }
  }
  return sum * multiplier;
}

console.log(productSum(input, 1))
*/
/*
const findTwoNumberSum = (array, target) => {
  let resp = [];

  for(i = 0, k = array.length - 1; i <= k; ) {
    let tmp = array[k] + array[i];
    if (tmp == target) {
      resp.push(array[i]);
      resp.push(array[k]);
      return resp;
    }
    if (tmp > target) {
      k--;
    } else {
      i++;
    }
  }
  return resp;
}

let array = [-2,2,4,6,7,12,14]
console.log(findTwoNumberSum(array, 13))
*/
let mainArray = [1, 34, 4, 7, 4, 3, -12, -7, 11, 45, 0];
let sub = [4, -7, 11, 0];

const validateSubsequence = (array, sub) => {
  let k = 0;
  for (i = 0; i < array.length && k < sub.length; i++) {
    if (array[i] == sub[k]) {
      k++;
    }
  }
  return k == sub.length;
};

let tree = {
  val: 10,
  left: {
    val: 5,
    right: {
      val: 7,
      left: {
        val: 6,
      },
      right: {
        val: 8,
      },
    },
    left: {
      val: 4,
    },
  },
  right: {
    val: 20,
    left: {
      val: 16,
      right: {
        val: 18,
      },
      left: {
        val: 13,
      },
    },
    right: {
      val: 30,
    },
  },
};

const findClosestValueInTree = (tree, target) => {
  let closestVal = tree.val;

  let node = tree;
  while (node != null) {
    if (Math.abs(node.val - target) < Math.abs(closestVal - target)) {
      closestVal = node.val;
    }
    if (closestVal - target == 0) {
      return closestVal;
    }
    if (target >= node.val) {
      node = node.right;
    } else {
      node = node.left;
    }
  }

  return closestVal;
};

console.log(findClosestValueInTree(tree, 29));

const branchSum = (tree) => {
  let result = [];
  doesSum(tree. tree.val, result);
  return result;
};
const doesSum = (node, previousVal, result) => {
  if (node == null) {
    result.push(previousVal);
    return;
  }
  doesSum(tree.left, tree.val, result);
  doesSum(tree.right, tree.val, result);
};
