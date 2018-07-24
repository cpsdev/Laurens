/**
  Copyright (C) 2012-2018 by Autodesk, Inc.
  All rights reserved.

  Okuma LB3000 Lathe post processor configuration.

  $Revision$
  $Date$

  FORKID {D93DAA65-1C09-402E-9871-3280B561D994}
*/

///////////////////////////////////////////////////////////////////////////////
//                        MANUAL NC COMMANDS
//
// The following ACTION commands are supported by this post.
//
//     partEject                  - Manually eject the part
//     useXZCMode                 - Force XZC mode for next operation
//     usePolarMode               - Force Polar mode for next operation
//
///////////////////////////////////////////////////////////////////////////////

/**
todo:
- cleanup
- check modal feed formats MM/REV MM MIN
- check G17 for onCyclePoint()
- check getSpindle(), results look wrong
*/

description = "Okuma Multus U3000 with OSP-300 control";
vendor = "OKUMA";
vendorUrl = "http://www.okuma.com";
legal = "Copyright (C) 2012-2018 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 24000;

longDescription = "Okuma Multus U3000 (OSP-300 control) post with support for mill-turn.";

extension = "min";
programNameIsInteger = false;
setCodePage("ascii");

capabilities = CAPABILITY_MILLING | CAPABILITY_TURNING;
tolerance = spatial(0.002, MM);

minimumChordLength = spatial(0.25, MM);
minimumCircularRadius = spatial(0.01, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.01);
maximumCircularSweep = toRad(90); // reduced sweep to break up circular moves on quadrant boundaries
allowHelicalMoves = true;
allowedCircularPlanes = undefined; // allow any circular motion
allowSpiralMoves = false;
highFeedrate = (unit == IN) ? 470 : 10000;


// user-defined properties
properties = {
  writeMachine: false, // write machine
  writeTools: false, // writes the tools
  maxTool: 12,  // maximum tool number
  showSequenceNumbers: true, // show sequence numbers
  sequenceNumberStart: 1, // first sequence number
  sequenceNumberIncrement: 1, // increment for sequence numbers
  sequenceNumberToolOnly: true, // output sequence numbers on tool change only
  optionalStop: true, // optional stop
  separateWordsWithSpace: true, // specifies that the words should be separated with a white space
  useRadius: false, // specifies that arcs should be output using the radius (R word) instead of the I, J, and K words.
  preloadTool: true, // preloads next tool on tool change if any
  maximumSpindleSpeed: 4200, // specifies the maximum spindle speed
  useParametricFeed: false, // specifies that feed should be output using Q values
  showNotes: false, // specifies that operation notes should be output.
  useCycles: true, // specifies that drilling cycles should be used.
  // gotPartCatcher: false, // specifies if the machine has a part catcher
  autoEject: false, // specifies if the part should be automatically ejected at end of program
  useTailStock: false, // specifies to use the tailstock or not
  gotChipConveyor: false, // specifies to use a chip conveyor Y/N
  homePositionX: 9999, // home position for X-axis
  homePositionY: 9999, // home position for Y-axis
  homePositionZ: 9999, // home position for Z-axis
  homePositionW: 1500, // home position for W-axis
  optimizeCaxisSelect: false, // optimize output of enable/disable C-axis codes
  transferUseTorque: false, // use torque control for stock-transfer
  writeVersion: false, // include version info
  gotSecondarySpindle: true, // machine has a secondary spindle
  useM960: true, // use M960 C-axis shortest direction instead of M15/M16 directional codes
  useSimpleThread: true, // outputs a G33 threading cycle, false outputs a G71 (standard) threading cycle
  CASOff: false, //Collision Avoidance system
  lowGear: false, //Use Low gear for turning operations.
  safeRetractDistance: 0.0 // distance to add to retract distance when rewinding rotary axes
};

// user-defined property definitions
propertyDefinitions = {
  writeMachine: {title:"Write machine", description:"Output the machine settings in the header of the code.", group:0, type:"boolean"},
  writeTools: {title:"Write tool list", description:"Output a tool list in the header of the code.", group:0, type:"boolean"},
  maxTool: {title:"Max tool number", description:"Defines the maximum tool number.", type:"integer", range:[0, 999999999]},
  showSequenceNumbers: {title:"Use sequence numbers", description:"Use sequence numbers for each block of outputted code.", group:1, type:"boolean"},
  sequenceNumberStart: {title:"Start sequence number", description:"The number at which to start the sequence numbers.", group:1, type:"integer"},
  sequenceNumberIncrement: {title:"Sequence number increment", description:"The amount by which the sequence number is incremented by in each block.", group:1, type:"integer"},
  sequenceNumberToolOnly: {title:"Sequence numbers only on tool change", description:"Output sequence numbers on tool changes instead of every line.", group:1, type:"boolean"},
  optionalStop: {title:"Optional stop", description:"Outputs optional stop code during when necessary in the code.", type:"boolean"},
  separateWordsWithSpace: {title:"Separate words with space", description:"Adds spaces between words if 'yes' is selected.", type:"boolean"},
  useRadius: {title:"Radius arcs", description:"If yes is selected, arcs are outputted using radius values rather than IJK.", type:"boolean"},
  maximumSpindleSpeed: {title:"Max spindle speed", description:"Defines the maximum spindle speed allowed by your machines.", type:"integer", range:[0, 999999999]},
  useParametricFeed:  {title:"Parametric feed", description:"Specifies the feed value that should be output using a Q value.", type:"boolean"},
  showNotes: {title:"Show notes", description:"Writes operation notes as comments in the outputted code.", type:"boolean"},
  useCycles: {title:"Use cycles", description:"Specifies if canned drilling cycles should be used.", type:"boolean"},
  // gotPartCatcher: {title:"Use part catcher", description:"Specifies whether part catcher code should be output.", type:"boolean"},
  autoEject: {title:"Auto eject", description:"Specifies whether the part should automatically eject at the end of a program.", type:"boolean"},
  useTailStock: {title:"Use tailstock", description:"Specifies whether to use the tailstock or not.", type:"boolean", presentation:"yesno"},
  gotChipConveyor: {title:"Got chip conveyor", description:"Specifies whether to use a chip conveyor.", type:"boolean", presentation:"yesno"},
  homePositionX: {title:"X home position in radius", description:"X home position specified in radius.", type:"spatial"},
  homePositionY: {title:"Y home position", description:"Y home position.", type:"spatial"},
  homePositionZ: {title:"Z home position", description:"Z home position.", type:"spatial"},
  homePositionW: {title:"W home position", description:"W home position.", type:"spatial"},
  optimizeCaxisSelect: {title:"Optimize C axis selection", description:"Optimizes the output of enable/disable C-axis codes.", type:"boolean"},
  transferUseTorque: {title:"Stock-transfer torque control", description:"Use torque control for stock transfer.", type:"boolean"},
  writeVersion: {title:"Write version", description:"Write the version number in the header of the code.", group:0, type:"boolean"},
  gotSecondarySpindle: {title:"Secondary spindle", description:"Specifies that the machine has a secondary spindle.", group:0, type:"boolean"},
  useM960: {title:"Use C-axis Shortest Direction Code", description:"Specifies that an M960 should be used to control the C-axis direction instead of the M15/M16 directional codes.", type:"boolean"},
  useSimpleThread: {title:"Use simple threading cycle", description:"Enable to output G33 simple threading cycle, disable to output G71 standard threading cycle.", type:"boolean"},
  safeRetractDistance: {title:"Safe retract distance", description:"Specifies the distance to add to retract distance when rewinding rotary axes.", type:"spatial"}
};

// samples:
// throughTool: {on: 88, off: 89}
// throughTool: {on: [8, 88], off: [9, 89]}
var coolants = {
  flood: {turret1: {on: 263, off: 262}, turret2: {on: 8, off: 9}},
  mist: {},
  throughTool: {turret1: {on: 175, off: 174}, turret2: {on: 8, off: 9}},
  air: {},
  airThroughTool: {turret1: {on: 51, off: 50}, turret2: {on: 51, off: 50}},
  suction: {},
  floodMist: {},
  floodThroughTool: {},
  off: 9
};

var permittedCommentChars = " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,=_-/";

var gFormat = createFormat({prefix:"G", decimals:0});
var mFormat = createFormat({prefix:"M", decimals:0});

var spatialFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var integerFormat = createFormat({decimals:0});
var xFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true, scale:2}); // diameter mode
var yFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var zFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var rFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true}); // radius
var abcFormat = createFormat({decimals:3, forceDecimal:true, scale:DEG});
var bFormat = createFormat({prefix:"(B=", suffix:")", decimals:3, forceDecimal:true, scale:DEG});
var cFormat = createFormat({decimals:3, forceDecimal:true, scale:DEG, cyclicLimit:toRad(359.9999)});
var feedFormat = createFormat({decimals:(unit == MM ? 2 : 3), forceDecimal:true});
var pitchFormat = createFormat({decimals:6, forceDecimal:true});
var toolFormat = createFormat({decimals:0, width:4, zeropad:true});
var tool1Format = createFormat({decimals:0, width:6, zeropad:true});
var orientationNumberFormat = createFormat({width:2, zeropad:true, decimals:0});
var rpmFormat = createFormat({decimals:0});
var secFormat = createFormat({decimals:2, forceDecimal:true}); // seconds - range 0.001-99999.999
var milliFormat = createFormat({decimals:0}); // milliseconds // range 1-9999
var taperFormat = createFormat({decimals:1, scale:DEG});

var xOutput = createVariable({onchange:function () {retracted = false;}, prefix:"X"}, xFormat);
var yOutput = createVariable({prefix:"Y"}, yFormat);
var zOutput = createVariable({onchange:function () {retracted = false;}, prefix:"Z"}, zFormat);
var wOutput = createVariable({prefix:"W"}, zFormat);
var aOutput = createVariable({prefix:"A"}, abcFormat);
var bOutput = createVariable({}, bFormat);
var cOutput = createVariable({prefix:"C"}, cFormat);
var feedOutput = createVariable({prefix:"F"}, feedFormat);
var pitchOutput = createVariable({prefix:"F", force:true}, pitchFormat);
var sOutput = createVariable({prefix:"S", force:true}, rpmFormat);
var sbOutput = createVariable({prefix:"SB=", force:true}, rpmFormat);
var eOutput = createVariable({prefix:"E", force:true}, secFormat);
var dwellOutput = createVariable({prefix:"F", force:true}, secFormat);
var rOutput = createVariable({prefix:"R", force:true}, rFormat);

// circular output
var iOutput = createReferenceVariable({prefix:"I", force: true}, spatialFormat);
var jOutput = createReferenceVariable({prefix:"J", force: true}, spatialFormat);
var kOutput = createReferenceVariable({prefix:"K", force: true}, spatialFormat);

var gMotionModal = createModal({}, gFormat); // modal group 1 // G0-G3, ...
var gPlaneModal = createModal({onchange:function () {gMotionModal.reset();}}, gFormat); // modal group 2 // G17-19
var gFeedModeModal = createModal({}, gFormat); // modal group 5 // G98-99
var gSpindleModeModal = createModal({}, gFormat); // modal group 5 // G96-97
var gSpindleModal = createModal({}, mFormat); // M176/177 SPINDLE MODE
var gAbsIncModal = createModal({}, gFormat); // modal group 6 // G90-91
var gCycleModal = createModal({}, gFormat); // modal group 9 // G81, ...
var gPolarModal = createModal({}, gFormat); // G137, G136
var gYaxisModal = createModal({}, gFormat);
var cAxisEngageModal = createModal({}, mFormat);
var cAxisBrakeModal = createModal({}, mFormat);
var mInterferModal = createModal({}, mFormat);
var cAxisEnableModal = createModal({}, mFormat);
var cAxisDirectionModal = createModal({}, mFormat);
var gSelectSpindleModal = createModal({}, gFormat);
var tailStockModal = createModal({}, mFormat);

// fixed settings
var firstFeedParameter = 100;

var gotYAxis = true;
var yAxisMinimum = toPreciseUnit(gotYAxis ? -125 : 0, MM); // specifies the minimum range for the Y-axis
var yAxisMaximum = toPreciseUnit(gotYAxis ? 125 : 0, MM); // specifies the maximum range for the Y-axis
var xAxisMinimum = toPreciseUnit(-125, MM); // specifies the maximum range for the X-axis (RADIUS MODE VALUE)
var gotBAxis = true; // B-axis always requires customization to match the machine specific functions for doing rotations
var bAxisIsManual = false; // B-axis is manually set and not programmable
var gotMultiTurret = true; // specifies if the machine has several turrets

var gotPolarInterpolation = true; // specifies if the machine has XY polar interpolation capabilities
var gotDoorControl = true;
var airCleanChuck = true; // use air to clean off chuck at part transfer and part eject
var linearizeXZCMode = false; // XZC mode requires linearization

var WARNING_WORK_OFFSET = 0;
var WARNING_REPEAT_TAPPING = 1;

var SPINDLE_MAIN = 0;
var SPINDLE_SUB = 1;
var SPINDLE_LIVE = 2;

var POSX = 0;
var POXY = 1;
var POSZ = 2;
var NEGZ = -2;

var TRANSFER_PHASE = 0;
var TRANSFER_SPEED = 1;
var TRANSFER_STOP = 2;

// collected state
var sequenceNumber;
var currentWorkOffset;
var optionalSection = false;
var forceSpindleSpeed = false;
var activeMovements; // do not use by default
var currentFeedId;
var previousSpindle;
var activeSpindle=0;
var currentRPM = 0;
var partCutoff = false;
var partWasCutOff = false;
var reverseTap = false;
var showSequenceNumbers;
var stockTransferIsActive = false;
var forceXZCMode = false; // forces XZC output, activated by Action:useXZCMode
var forcePolarMode = false; // force Polar output, activated by Action:usePolarMode
var tapping = false;
var threading = false;
var ejectRoutine = false;
var bestABCIndex = undefined;
var G127isActive = false;
var retracted = false; // specifies that the tool has been retracted to the safe plane
var waitNumber = 10;
var isNewSpindle = false;
var HSSC = false;
var machiningMode = 0;
var lowGear = false;
var korteRetract = false;
var onSpindleSpeedForce = false;

var machineState = {
  liveToolIsActive: undefined,
  cAxisIsEngaged: undefined,
  machiningDirection: undefined,
  mainSpindleIsActive: undefined,
  subSpindleIsActive: undefined,
  mainSpindleBrakeIsActive: undefined,
  subSpindleBrakeIsActive: undefined,
  tailstockIsActive: undefined,
  usePolarMode: undefined,
  useXZCMode: undefined,
  axialCenterDrilling: undefined,
  currentBAxisOrientationTurning: new Vector(0, 0, 0),
  yAxisModeIsActive: undefined,
  currentTurret: undefined
};


function getCode(code, spindle) {
  switch(code) {
  case "PART_CATCHER_ON":
    return 77;
  case "PART_CATCHER_OFF":
    return 76;
  case "TAILSTOCK_ON":
    machineState.tailstockIsActive = true;
    return 21;
  case "TAILSTOCK_OFF":
    machineState.tailstockIsActive = false;
    return 20;
  case "SET_SPINDLE_FRAME":
    break;
  case "ENABLE_Y_AXIS":
    setRadiusDiameterMode("radius");
    machineState.yAxisModeIsActive = true;
    return 138;
  case "DISABLE_Y_AXIS":
    setRadiusDiameterMode("diameter");
    machineState.yAxisModeIsActive = false;
    return 136;
  case "ENABLE_C_AXIS":
    machineState.cAxisIsEngaged = true;
    return 110;
  case "DISABLE_C_AXIS":
    machineState.cAxisIsEngaged = false;
    return 109;
  case "POLAR_INTERPOLATION_ON":
    return 137;
  case "POLAR_INTERPOLATION_OFF":
    return 136;
  case "ENABLE_TURNING":
    return 270;
  case "STOP_SPINDLE":
    switch (spindle) {
    case SPINDLE_MAIN:
    case SPINDLE_SUB:
      machineState.mainSpindleIsActive = false;
      machineState.subSpindleIsActive = false;
      return 5;
    case SPINDLE_LIVE:
      machineState.liveToolIsActive = false;
      return 12;
    }
    break;
  case "ORIENT_SPINDLE":
    return (spindle == SPINDLE_MAIN) ? 19 : 239;
  case "START_SPINDLE_CW":
    switch (spindle) {
    case SPINDLE_MAIN:
      machineState.mainSpindleIsActive = true;
      return 3;
    case SPINDLE_SUB:
      machineState.subSpindleIsActive = true;
      return 3;
    case SPINDLE_LIVE:
      machineState.liveToolIsActive = true;
      return 13;
    }
    break;
  case "START_SPINDLE_CCW":
  switch (spindle) {
    case SPINDLE_MAIN:
      machineState.mainSpindleIsActive = true;
      return 4;
    case SPINDLE_SUB:
      machineState.subSpindleIsActive = true;
      return 4;
    case SPINDLE_LIVE:
      machineState.liveToolIsActive = true;
      return 14;
    }
    break;
  case "FEED_MODE_MM_REV":
    return 95;
  case "FEED_MODE_MM_MIN":
    return 94;
  case "CONSTANT_SURFACE_SPEED_ON":
    machineState.constantSurfaceSpeedIsActive = true;
    return 96;
  case "CONSTANT_SURFACE_SPEED_OFF":
    machineState.constantSurfaceSpeedIsActive = false;
    return 97;
  case "AUTO_AIR_ON":
    break;
  case "AUTO_AIR_OFF":
    break;
  case "LOCK_MULTI_AXIS":
    return 147;
  case "UNLOCK_MULTI_AXIS":
    return 146;
  case "C_AXIS_CW":
    return 15;
  case "C_AXIS_CCW":
    return 16;
  case "CLAMP_CHUCK":
    return (spindle == SPINDLE_MAIN) ? 83 : 248;
  case "UNCLAMP_CHUCK":
    return (spindle == SPINDLE_MAIN) ? 84 : 249;
  case "SPINDLE_SYNCHRONIZATION_PHASE":
    break;
  case "SPINDLE_SYNCHRONIZATION_SPEED":
    return 151;
  case "SPINDLE_SYNCHRONIZATION_OFF":
    return 150;
  case "IGNORE_SPINDLE_ORIENTATION":
    return 210;
  case "TORQUE_LIMIT_ON":
    return 29;
  case "TORQUE_LIMIT_OFF":
    return 28;
  case "TORQUE_SKIP_ON":
    return 22;
  case "SELECT_SPINDLE":
    switch (spindle) {
    case SPINDLE_MAIN:
      return 140;
    case SPINDLE_SUB:
      return 141;
    }
    break;
  case "RIGID_TAPPING":
    break;
  case "INTERNAL_INTERLOCK_ON":
    return (spindle == SPINDLE_MAIN) ? 185 : 247;
  case "INTERNAL_INTERLOCK_OFF":
    return (spindle == SPINDLE_MAIN) ? 184 : 246;
  case "INTERFERENCE_CHECK_OFF":
    break;
  case "INTERFERENCE_CHECK_ON":
    break;
  case "CYCLE_PART_EJECTOR":
    break;
  default:
    error(localize("Command " + code + " is not defined."));
    return 0;
  }
  return 0;
}

/** Returns the modulus. */
function getModulus(x, y) {
  return Math.sqrt(x * x + y * y);
}

/**
  Returns the C rotation for the given X and Y coordinates.
*/
function getC(x, y) {
  var direction;
  if (Vector.dot(machineConfiguration.getAxisU().getAxis(), new Vector(0, 0, 1)) != 0) {
    direction = (machineConfiguration.getAxisU().getAxis().getCoordinate(2) >= 0) ? 1 : -1; // C-axis is the U-axis
  } else {
    direction = (machineConfiguration.getAxisV().getAxis().getCoordinate(2) >= 0) ? 1 : -1; // C-axis is the V-axis
  }

  var c = Math.atan2(y, x) * direction;
  if (c < 0) {
    c += Math.PI * 2;
  }
  return c;
}

/**
  Returns the C rotation for the given X and Y coordinates in the desired rotary direction.
*/
function getCClosest(x, y, _c, clockwise) {
  if (_c == Number.POSITIVE_INFINITY) {
    _c = 0; // undefined
  }
  if (!xFormat.isSignificant(x) && !yFormat.isSignificant(y)) { // keep C if XY is on center
    return _c;
  }
  var c = getC(x, y);
  if (c < 0) {
    c += Math.PI * 2;
  }
  return c;

/*
  if (clockwise != undefined) {
    if (clockwise) {
      while (c < _c) {
        c += Math.PI * 2;
      }
    } else {
      while (c > _c) {
        c -= Math.PI * 2;
      }
    }
  } else {
    min = _c - Math.PI;
    max = _c + Math.PI;
    while (c < min) {
      c += Math.PI * 2;
    }
    while (c > max) {
      c -= Math.PI * 2;
    }
  }
  return c;
*/
}

/**
  Returns the desired tolerance for the given section.
*/
function getTolerance() {
  var t = tolerance;
  if (hasParameter("operation:tolerance")) {
    if (t > 0) {
      t = Math.min(t, getParameter("operation:tolerance"));
    } else {
      t = getParameter("operation:tolerance");
    }
  }
  return t;
}

/**
  Outputs the C-axis direction code.
*/
function setCAxisDirection(previous, current) {
  if (!properties.useM960) {
    var delta = current - previous;
    if (((delta < 0) && (delta > -Math.PI)) || (delta > Math.PI)) {
      writeBlock(cAxisDirectionModal.format(getCode("C_AXIS_CCW", getSpindle(true))));
    } else if (abcFormat.getResultingValue(delta) != 0) {
      writeBlock(cAxisDirectionModal.format(getCode("C_AXIS_CW", getSpindle(true))));
    }
  }
}

function formatSequenceNumber() {
  if (sequenceNumber > 99999) {
    sequenceNumber = properties.sequenceNumberStart;
  }
  var seqno = "N" + sequenceNumber;
  sequenceNumber += properties.sequenceNumberIncrement;
  return seqno;
}

/**
  Writes the specified block.
*/
function writeBlock() {
  var seqno = "";
  var opskip = "";
  if (showSequenceNumbers) {
    seqno = formatSequenceNumber();
  }
  if (optionalSection) {
    opskip = "/";
  }
  var text = formatWords(arguments);
  if (text) {
    writeWords(opskip, seqno, text);
    if (properties.sequenceNumberToolOnly) {
      showSequenceNumbers = false;
    }
  }
}

function writeDebug(_text) {
  writeComment("DEBUG - " + _text);
}

function formatComment(text) {
  return "(" + String(filterText(String(text).toUpperCase(), permittedCommentChars)).replace(/[\(\)]/g, "") + ")";
}

/**
  Output a comment.
*/
function writeComment(text) {
  writeln(formatComment(text));
}

function getB(abc, section) {
/*
  if (section.spindle == SPINDLE_PRIMARY) {
    return abc.y;
  } else {
    return Math.PI - abc.y;
  }
*/
  return abc.y;
}

function writeCommentSeqno(text) {
  writeln(formatSequenceNumber() + formatComment(text));
}

function defineBAxis() {
  if (bAxisIsManual) {
    bFormat = createFormat({prefix:"(B=", suffix:")", decimals:3, forceDecimal:true, scale:DEG});
    bOutput = createVariable({}, bFormat);
  } else {
    bFormat = createFormat({prefix:"B", decimals:3, forceDecimal:true, scale:DEG});
    bOutput = createVariable({}, bFormat);
    barOutput = createVariable({prefix:"W", force:true}, spatialFormat);
  }
}

var machineConfigurationMainSpindle;
var machineConfigurationSubSpindle;

function onOpen() {
  if (properties.useRadius) {
    maximumCircularSweep = toRad(90); // avoid potential center calculation errors for CNC
  }

  // Copy certain properties into global variables
  showSequenceNumbers = properties.sequenceNumberToolOnly ? false : properties.showSequenceNumbers;

  // Setup default M-codes
  // mInterferModal.format(getCode("INTERFERENCE_CHECK_ON", SPINDLE_MAIN));

  if (true) {
    var bAxisMain = createAxis({coordinate:1, table:false, axis:[0, -1, 0], range:[0, 210.001], preference:0});
    var cAxisMain = createAxis({coordinate:2, table:true, axis:[0, 0, 1], cyclic:true, range:[0, 359.999], preference:0}); // C axis is modal between primary and secondary spindle

    var bAxisSub = createAxis({coordinate:1, table:false, axis:[0, -1, 0], range:[0, 210.001], preference:0});
    var cAxisSub = createAxis({coordinate:2, table:true, axis:[0, 0, 1], cyclic:true, range:[0, 359.999], preference:0}); // C axis is modal between primary and secondary spindle

    machineConfigurationMainSpindle = gotBAxis ? new MachineConfiguration(bAxisMain, cAxisMain) : new MachineConfiguration(cAxisMain);
    machineConfigurationSubSpindle =  gotBAxis ? new MachineConfiguration(bAxisSub, cAxisSub) : new MachineConfiguration(cAxisSub);
  }

  machineConfiguration = new MachineConfiguration(); // creates an empty configuration to be able to set eg vendor information
  
  machineConfiguration.setVendor("OKUMA");
  machineConfiguration.setModel("Multus U3000");
  
  yOutput.disable();
  gPolarModal.format(getCode("DISABLE_Y_AXIS", true));

  aOutput.disable();
  if (!gotBAxis) {
    bOutput.disable();
  } else {
    defineBAxis();
  }

  if (highFeedrate <= 0) {
    error(localize("You must set 'highFeedrate' because axes are not synchronized for rapid traversal."));
    return;
  }

  if (!properties.separateWordsWithSpace) {
    setWordSeparator("");
  }

  sequenceNumber = properties.sequenceNumberStart;

  if (programName) {
    var programId = parseInt(programName, 10);
    if ((programId >= 1) && (programId <= 9999)) {
      var oFormat = createFormat({width:4, zeropad:true, decimals:0});
      writeln("O" + oFormat.format(programId));
    }
  }


  // Select the active spindle
  if (properties.gotSecondarySpindle) {
    // writeBlock(gSelectSpindleModal.format(getCode("SELECT_SPINDLE", getSection(0).spindle))); // cannot use getSpindle since there is not an active section
  }

  if (programComment) {
    writeln(formatComment(programComment));
  }

  if (properties.writeVersion) {
    if ((typeof getHeaderVersion == "function") && getHeaderVersion()) {
      writeComment(localize("post version") + ": " + getHeaderVersion());
    }
    if ((typeof getHeaderDate == "function") && getHeaderDate()) {
      writeComment(localize("post modified") + ": " + getHeaderDate());
    }
  }

  // dump machine configuration
  var vendor = machineConfiguration.getVendor();
  var model = machineConfiguration.getModel();
  var description = machineConfiguration.getDescription();

  if (properties.writeMachine && (vendor || model || description)) {
    writeComment(localize("Machine"));
    if (vendor) {
      writeComment("  " + localize("vendor") + ": " + vendor);
    }
    if (model) {
      writeComment("  " + localize("model") + ": " + model);
    }
    if (description) {
      writeComment("  " + localize("description") + ": "  + description);
    }
  }

  // dump tool information
  if (properties.writeTools) {
    var zRanges = {};
    if (is3D()) {
      var numberOfSections = getNumberOfSections();
      for (var i = 0; i < numberOfSections; ++i) {
        var section = getSection(i);
        var zRange = section.getGlobalZRange();
        var tool = section.getTool();
        if (zRanges[tool.number]) {
          zRanges[tool.number].expandToRange(zRange);
        } else {
          zRanges[tool.number] = zRange;
        }
      }
    }

    var tools = getToolTable();
    if (tools.getNumberOfTools() > 0) {
      for (var i = 0; i < tools.getNumberOfTools(); ++i) {
        var tool = tools.getTool(i);
        var compensationOffset = tool.isTurningTool() ? tool.compensationOffset : tool.lengthOffset;
        var comment = "T" + toolFormat.format(tool.number * 100 + compensationOffset % 100) + " " +
          "D=" + spatialFormat.format(tool.diameter) + " " +
          localize("CR") + "=" + spatialFormat.format(tool.cornerRadius);
        if ((tool.taperAngle > 0) && (tool.taperAngle < Math.PI)) {
          comment += " " + localize("TAPER") + "=" + taperFormat.format(tool.taperAngle) + localize("deg");
        }
        if (zRanges[tool.number]) {
          comment += " - " + localize("ZMIN") + "=" + spatialFormat.format(zRanges[tool.number].getMinimum());
        }
        comment += " - " + getToolTypeName(tool.type);
        writeComment(comment);
      }
    }
  }

  if (false) {
    // check for duplicate tool number
    for (var i = 0; i < getNumberOfSections(); ++i) {
      var sectioni = getSection(i);
      var tooli = sectioni.getTool();
      for (var j = i + 1; j < getNumberOfSections(); ++j) {
        var sectionj = getSection(j);
        var toolj = sectionj.getTool();
        if (tooli.number == toolj.number) {
          if (spatialFormat.areDifferent(tooli.diameter, toolj.diameter) ||
              spatialFormat.areDifferent(tooli.cornerRadius, toolj.cornerRadius) ||
              abcFormat.areDifferent(tooli.taperAngle, toolj.taperAngle) ||
              (tooli.numberOfFlutes != toolj.numberOfFlutes)) {
            error(
              subst(
                localize("Using the same tool number for different cutter geometry for operation '%1' and '%2'."),
                sectioni.hasParameter("operation-comment") ? sectioni.getParameter("operation-comment") : ("#" + (i + 1)),
                sectionj.hasParameter("operation-comment") ? sectionj.getParameter("operation-comment") : ("#" + (j + 1))
              )
            );
            return;
          }
        }
      }
    }
  }

  writeBlock(gAbsIncModal.format(90), gCycleModal.format(80));
  writeBlock(gFormat.format((getSection(0).getTool().turret == 2) ? 14 : 13));
  writeBlock(gFormat.format(140));
  writeBlock("P2");
  if (getSection(0).spindle == SPINDLE_PRIMARY) {
    writeBlock(gFormat.format(20), "HP=" + spatialFormat.format(1)); // retract
  } else {
    writeBlock(gFormat.format(20), "HP=" + spatialFormat.format(2)); // retract
  }
  writeBlock(mFormat.format(331));
  writeln("CLEAR");
  writeln("DRAW");
  writeBlock(gFormat.format(50), sOutput.format(properties.maximumSpindleSpeed));
  writeBlock(gFormat.format(141));
  writeBlock(gFormat.format(50), sOutput.format(properties.maximumSpindleSpeed));
  writeBlock(gFormat.format(110));
  writeBlock(mFormat.format(216));

  writeBlock(gFormat.format((getSection(0).getTool().turret == 2) ? 13 : 14));
  writeBlock(gFormat.format(141));
  onCommand(COMMAND_CLOSE_DOOR);
  if (getSection(0).spindle == SPINDLE_PRIMARY) {
    writeBlock(gFormat.format(20), "HP=" + spatialFormat.format(1)); // retract
  } else {
    writeBlock(gFormat.format(20), "HP=" + spatialFormat.format(2)); // retract
  }
  writeBlock(gFormat.format(50), sOutput.format(properties.maximumSpindleSpeed));
  writeBlock(gFormat.format(140));
  writeBlock(gFormat.format(50), sOutput.format(properties.maximumSpindleSpeed));
  writeBlock(gFormat.format(111));
  writeBlock(mFormat.format(216));

  if (properties.useM960) {
    writeBlock(mFormat.format(960));
  }

  if (properties.gotChipConveyor) {
    onCommand(COMMAND_START_CHIP_TRANSPORT);
  }
  
  // automatically eject part at end of program
  if (properties.autoEject) {
    ejectRoutine = true;
  }
}

function onComment(message) {
  writeComment(message);
}

/** Force output of X, Y, and Z. */
function forceXYZ() {
  xOutput.reset();
  yOutput.reset();
  zOutput.reset();
}

/** Force output of A, B, and C. */
function forceABC() {
  aOutput.reset();
  bOutput.reset();
  cOutput.reset();
}

function forceFeed() {
  currentFeedId = undefined;
  feedOutput.reset();
}

/** Force output of X, Y, Z, A, B, C, and F on next output. */
function forceAny() {
  forceXYZ();
  forceABC();
  forceFeed();
}

function forceUnlockMultiAxis() {
  cAxisBrakeModal.reset();
}

function FeedContext(id, description, feed) {
  this.id = id;
  this.description = description;
  this.feed = feed;
}

function getFeed(f) {
  if (activeMovements) {
    var feedContext = activeMovements[movement];
    if (feedContext != undefined) {
      if (!feedFormat.areDifferent(feedContext.feed, f)) {
        if (feedContext.id == currentFeedId) {
          return ""; // nothing has changed
        }
        forceFeed();
        currentFeedId = feedContext.id;
        return "F=V" + (firstFeedParameter + feedContext.id);
      }
    }
    currentFeedId = undefined; // force Q feed next time
  }
  return feedOutput.format(f); // use feed value
}

function initializeActiveFeeds() {
  activeMovements = new Array();
  var movements = currentSection.getMovements();
  var feedPerRev = currentSection.feedMode == FEED_PER_REVOLUTION;

  var id = 0;
  var activeFeeds = new Array();
  if (hasParameter("operation:tool_feedCutting")) {
    if (movements & ((1 << MOVEMENT_CUTTING) | (1 << MOVEMENT_LINK_TRANSITION) | (1 << MOVEMENT_EXTENDED))) {
      var feedContext = new FeedContext(id, localize("Cutting"), feedPerRev ? getParameter("operation:tool_feedCuttingRel") : getParameter("operation:tool_feedCutting"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_CUTTING] = feedContext;
      activeMovements[MOVEMENT_LINK_TRANSITION] = feedContext;
      activeMovements[MOVEMENT_EXTENDED] = feedContext;
    }
    ++id;
    if (movements & (1 << MOVEMENT_PREDRILL)) {
      feedContext = new FeedContext(id, localize("Predrilling"), feedPerRev ? getParameter("operation:tool_feedCuttingRel") : getParameter("operation:tool_feedCutting"));
      activeMovements[MOVEMENT_PREDRILL] = feedContext;
      activeFeeds.push(feedContext);
    }
    ++id;
  }

  if (hasParameter("operation:finishFeedrate")) {
    if (movements & (1 << MOVEMENT_FINISH_CUTTING)) {
      var finishFeedrateRel;
      if (hasParameter("operation:finishFeedrateRel")) {
        finishFeedrateRel = getParameter("operation:finishFeedrateRel");
      } else if (hasParameter("operation:finishFeedratePerRevolution")) {
        finishFeedrateRel = getParameter("operation:finishFeedratePerRevolution");
      }
      var feedContext = new FeedContext(id, localize("Finish"), feedPerRev ? finishFeedrateRel : getParameter("operation:finishFeedrate"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_FINISH_CUTTING] = feedContext;
    }
    ++id;
  } else if (hasParameter("operation:tool_feedCutting")) {
    if (movements & (1 << MOVEMENT_FINISH_CUTTING)) {
      var feedContext = new FeedContext(id, localize("Finish"), feedPerRev ? getParameter("operation:tool_feedCuttingRel") : getParameter("operation:tool_feedCutting"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_FINISH_CUTTING] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:tool_feedEntry")) {
    if (movements & (1 << MOVEMENT_LEAD_IN)) {
      var feedContext = new FeedContext(id, localize("Entry"), feedPerRev ? getParameter("operation:tool_feedEntryRel") : getParameter("operation:tool_feedEntry"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LEAD_IN] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:tool_feedExit")) {
    if (movements & (1 << MOVEMENT_LEAD_OUT)) {
      var feedContext = new FeedContext(id, localize("Exit"), feedPerRev ? getParameter("operation:tool_feedExitRel") : getParameter("operation:tool_feedExit"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LEAD_OUT] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:noEngagementFeedrate")) {
    if (movements & (1 << MOVEMENT_LINK_DIRECT)) {
      var feedContext = new FeedContext(id, localize("Direct"), feedPerRev ? getParameter("operation:noEngagementFeedrateRel") : getParameter("operation:noEngagementFeedrate"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LINK_DIRECT] = feedContext;
    }
    ++id;
  } else if (hasParameter("operation:tool_feedCutting") &&
             hasParameter("operation:tool_feedEntry") &&
             hasParameter("operation:tool_feedExit")) {
    if (movements & (1 << MOVEMENT_LINK_DIRECT)) {
      var feedContext = new FeedContext(
        id,
        localize("Direct"),
        Math.max(
          feedPerRev ? getParameter("operation:tool_feedCuttingRel") : getParameter("operation:tool_feedCutting"),
          feedPerRev ? getParameter("operation:tool_feedEntryRel") : getParameter("operation:tool_feedEntry"),
          feedPerRev ? getParameter("operation:tool_feedExitRel") : getParameter("operation:tool_feedExit")
        )
      );
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LINK_DIRECT] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:reducedFeedrate")) {
    if (movements & (1 << MOVEMENT_REDUCED)) {
      var feedContext = new FeedContext(id, localize("Reduced"), feedPerRev ? getParameter("operation:reducedFeedrateRel") : getParameter("operation:reducedFeedrate"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_REDUCED] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:tool_feedRamp")) {
    if (movements & ((1 << MOVEMENT_RAMP) | (1 << MOVEMENT_RAMP_HELIX) | (1 << MOVEMENT_RAMP_PROFILE) | (1 << MOVEMENT_RAMP_ZIG_ZAG))) {
      var feedContext = new FeedContext(id, localize("Ramping"), feedPerRev ? getParameter("operation:tool_feedRampRel") : getParameter("operation:tool_feedRamp"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_RAMP] = feedContext;
      activeMovements[MOVEMENT_RAMP_HELIX] = feedContext;
      activeMovements[MOVEMENT_RAMP_PROFILE] = feedContext;
      activeMovements[MOVEMENT_RAMP_ZIG_ZAG] = feedContext;
    }
    ++id;
  }
  if (hasParameter("operation:tool_feedPlunge")) {
    if (movements & (1 << MOVEMENT_PLUNGE)) {
      var feedContext = new FeedContext(id, localize("Plunge"), feedPerRev ? getParameter("operation:tool_feedPlungeRel") : getParameter("operation:tool_feedPlunge"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_PLUNGE] = feedContext;
    }
    ++id;
  }
  if (true) { // high feed
    if (movements & (1 << MOVEMENT_HIGH_FEED)) {
      var feedContext = new FeedContext(id, localize("High Feed"), this.highFeedrate);
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_HIGH_FEED] = feedContext;
    }
    ++id;
  }

  for (var i = 0; i < activeFeeds.length; ++i) {
    var feedContext = activeFeeds[i];
    writeBlock("V" + (firstFeedParameter + feedContext.id) + "=" + feedFormat.format(feedContext.feed), formatComment(feedContext.description));
  }
}

var currentWorkPlaneABC = undefined;

function forceWorkPlane() {
  currentWorkPlaneABC = undefined;
}

function setWorkPlane(abc) {
  // milling only

  if (!machineConfiguration.isMultiAxisConfiguration()) {
    return; // ignore
  }

  if (!((currentWorkPlaneABC == undefined) ||
        abcFormat.areDifferent(abc.x, currentWorkPlaneABC.x) ||
        abcFormat.areDifferent(abc.y, currentWorkPlaneABC.y) ||
        abcFormat.areDifferent(abc.z, currentWorkPlaneABC.z))) {
    return; // no change
  }

  onCommand(COMMAND_UNLOCK_MULTI_AXIS);
  zOutput.reset();

  if (!retracted) {
    if (currentSection.isPatterned() && korteRetract) {
    writeComment("No Retract due to user - Manual NC");
    } else if (currentSection.isPatterned()) {
      writeRetract(X);
    } else {
      if (!stockTransferIsActive) {
        writeRetract();
      }
    }
    // writeRetract(X);
    // writeRetract(Z);
  }
  writeBlock(
    gMotionModal.format(0),
    conditional(machineConfiguration.isMachineCoordinate(0), "A" + abcFormat.format(abc.x)),
    conditional(machineConfiguration.isMachineCoordinate(1), "BA=" + abcFormat.format(abc.y)),
    conditional(machineConfiguration.isMachineCoordinate(2), "C" + abcFormat.format(abc.z))
  );
  if (abc.isNonZero()) {
    // note G127 with 0 is not allowed, use G126 for this
    writeBlock(gFormat.format(127), "B" + abcFormat.format(abc.y) + " (" + "ENABLE TILTED WORKPLANE" + ")");
    G127isActive = true;
  }
  if (!machineState.useXZCMode && !machineState.usePolarMode) {
    onCommand(COMMAND_LOCK_MULTI_AXIS);
  }

  currentWorkPlaneABC = abc;
}

function getBestABC(section, workPlane, which) {
  var W = workPlane;
  var abc = machineConfiguration.getABC(W);
  if (which == undefined) { // turning, XZC, Polar modes
    return abc;
  }
  if (Vector.dot(machineConfiguration.getAxisU().getAxis(), new Vector(0, 0, 1)) != 0) {
    var axis = machineConfiguration.getAxisU(); // C-axis is the U-axis
  } else {
    var axis = machineConfiguration.getAxisV(); // C-axis is the V-axis
  }
  if (axis.isEnabled() && axis.isTable()) {
    var ix = axis.getCoordinate();
    var rotAxis = axis.getAxis();
    if (isSameDirection(machineConfiguration.getDirection(abc), rotAxis) ||
        isSameDirection(machineConfiguration.getDirection(abc), Vector.product(rotAxis, -1))) {
      var direction = isSameDirection(machineConfiguration.getDirection(abc), rotAxis) ? 1 : -1;
      var box = section.getGlobalBoundingBox();
      switch (which) {
      case 1:
        x = box.upper.x - box.lower.x;
        y = box.upper.y - box.lower.y;
        break;
      case 2:
        x = box.lower.x;
        y = box.lower.y;
        break;
      case 3:
        x = box.upper.x;
        y = box.lower.y;
        break;
      case 4:
        x = box.upper.x;
        y = box.upper.y;
        break;
      case 5:
        x = box.lower.x;
        y = box.upper.y;
        break;
      default:
        var R = machineConfiguration.getRemainingOrientation(abc, W);
        x = R.right.x;
        y = R.right.y;
        break;
      }
      abc.setCoordinate(ix, getCClosest(x, y, cOutput.getCurrent()));
    }
  }
  // writeComment("Which = " + which + "  Angle = " + abc.z)
  return abc;
}

var closestABC = false; // choose closest machine angles
var currentMachineABC;

function getWorkPlaneMachineABC(section, workPlane) {
  var W = workPlane; // map to global frame

  // var abc = machineConfiguration.getABC(W);
  var abc = getBestABC(section, workPlane, bestABCIndex);
  if (closestABC) {
    if (currentMachineABC) {
      abc = machineConfiguration.remapToABC(abc, currentMachineABC);
    } else {
      abc = machineConfiguration.getPreferredABC(abc);
    }
  } else {
    abc = machineConfiguration.getPreferredABC(abc);
  }

  try {
    abc = machineConfiguration.remapABC(abc);
    currentMachineABC = abc;
  } catch (e) {
    error(
      localize("Machine angles not supported") + ":"
      + conditional(machineConfiguration.isMachineCoordinate(0), " A" + abcFormat.format(abc.x))
      + conditional(machineConfiguration.isMachineCoordinate(1), " B" + abcFormat.format(abc.y))
      + conditional(machineConfiguration.isMachineCoordinate(2), " C" + abcFormat.format(abc.z))
    );
    return abc;
  }

  var direction = machineConfiguration.getDirection(abc);
  if (!isSameDirection(direction, W.forward)) {
    error(localize("Orientation not supported."));
    return abc;
  }

  if (!machineConfiguration.isABCSupported(abc)) {
    error(
      localize("Work plane is not supported") + ":"
      + conditional(machineConfiguration.isMachineCoordinate(0), " A" + abcFormat.format(abc.x))
      + conditional(machineConfiguration.isMachineCoordinate(1), " B" + abcFormat.format(abc.y))
      + conditional(machineConfiguration.isMachineCoordinate(2), " C" + abcFormat.format(abc.z))
    );
    return abc;
  }
  if (!machineState.isTurningOperation) {
    var tcp = false;
    if (tcp) {
      setRotation(W); // TCP mode
    } else {
      var O = machineConfiguration.getOrientation(abc);
      var R = machineConfiguration.getRemainingOrientation(abc, W);
      setRotation(R);
    }
  }

  return abc;
}

function getBAxisOrientationTurning(section) {
  if (tool.turret == 2) {
    return new Vector(0, 0, 1);
  }
  var toolAngle = hasParameter("operation:tool_angle") ? getParameter("operation:tool_angle") : 0;
  var toolOrientation = section.toolOrientation;
  if (toolAngle && toolOrientation != 0) {
    error(localize("You cannot use tool angle and tool orientation together in operation " + "\"" + (getParameter("operation-comment")) + "\""));
  }

  var angle;
  if (false) {
    angle = toRad(toolAngle) + toolOrientation;
  } else {
    if (tool.vendor) {
      angle = toRad(parseFloat(tool.vendor));
    } else {
      error(localize("B- Axis Orientation is empty in operation " + "\"" + (getParameter("operation-comment").toUpperCase()) + "\""));
      return undefined;
    }
  }

  var direction;
  if (Vector.dot(machineConfiguration.getAxisU().getAxis(), new Vector(0, 1, 0)) != 0) {
    direction = (machineConfiguration.getAxisU().getAxis().getCoordinate(1) >= 0) ? 1 : -1; // B-axis is the U-axis
  } else {
    direction = (machineConfiguration.getAxisV().getAxis().getCoordinate(1) >= 0) ? 1 : -1; // B-axis is the V-axis
  }

  // var mappedWorkplane = new Matrix(new Vector(0, direction, 0), Math.PI/2 - (angle * direction));
  var mappedWorkplane = new Matrix(new Vector(0, -direction, 0), angle);
  var abc = getWorkPlaneMachineABC(section, mappedWorkplane);

  return abc;
}

function getSpindle(partSpindle) {
  // safety conditions
  if (getNumberOfSections() == 0) {
    return SPINDLE_MAIN;
  }
  if (getCurrentSectionId() < 0) {
    if (machineState.liveToolIsActive && !partSpindle) {
      return SPINDLE_LIVE;
    } else {
      return getSection(getNumberOfSections() - 1).spindle;
    }
  }

  // Turning is active or calling routine requested which spindle part is loaded into
  if (machineState.isTurningOperation || machineState.axialCenterDrilling || partSpindle || stockTransferIsActive) {
    return currentSection.spindle;
  //Milling is active
  } else {
    return SPINDLE_LIVE;
  }
}

function getSecondarySpindle() {
  var spindle = getSpindle(true);
  return (spindle == SPINDLE_MAIN) ? SPINDLE_SUB : SPINDLE_MAIN;
}

function isPerpto(a, b) {
  return Math.abs(Vector.dot(a, b)) < (1e-7);
}

function setSpindleOrientationTurning(section) {
  var J; // cutter orientation
  var R; // cutting quadrant
  var leftHandTool = (hasParameter("operation:tool_hand") && (getParameter("operation:tool_hand") == "L" || getParameter("operation:tool_holderType") == 0));
  if (hasParameter("operation:machineInside")) {
    if (getParameter("operation:machineInside") == 0) {
      R = (currentSection.spindle == SPINDLE_PRIMARY) ? 3 : 4;
    } else {
      R = (currentSection.spindle == SPINDLE_PRIMARY) ? 2 : 1;
    }
  } else {
    if ((hasParameter("operation-strategy") && getParameter("operation-strategy") == "turningFace") ||
      (hasParameter("operation-strategy") && getParameter("operation-strategy") == "turningPart")) {
      R = (currentSection.spindle == SPINDLE_PRIMARY) ? 3 : 4;
    } else {
      error(subst(localize("Failed to identify spindle orientation for operation \"%1\"."), getOperationComment()));
      return;
    }
  }
  if (leftHandTool) {
    J = (currentSection.spindle == SPINDLE_PRIMARY) ? 2 : 1;
  } else {
    J = (currentSection.spindle == SPINDLE_PRIMARY) ? 1 : 2;
  }
  writeComment("Post processor is not customized, add code for cutter orientation and cutting quadrant here if needed.");
}

function isProbeOperation() {
  return hasParameter("operation-strategy") && (getParameter("operation-strategy") == "probe");
}

var bAxisOrientationTurning = new Vector(0, 0, 0);

function onSection() {

  // Detect machine configuration
  machineConfiguration = (currentSection.spindle == SPINDLE_PRIMARY) ? machineConfigurationMainSpindle : machineConfigurationSubSpindle;
  if (!gotBAxis) {
    if ((getMachiningDirection(currentSection) == MACHINING_DIRECTION_AXIAL) && !currentSection.isMultiAxis()) {
      machineConfiguration.setSpindleAxis(new Vector(0, 0, 1));
    } else {
      machineConfiguration.setSpindleAxis(new Vector(1, 0, 0));
    }
  } else {
    machineConfiguration.setSpindleAxis(new Vector(0, 0, 1)); // set the spindle axis depending on B0 orientation
  }

  setMachineConfiguration(machineConfiguration);
  currentSection.optimizeMachineAnglesByMachine(machineConfiguration, 0); // map tip mode
  
  // Define Machining modes
  tapping = hasParameter("operation:cycleType") &&
    ((getParameter("operation:cycleType") == "tapping") ||
     (getParameter("operation:cycleType") == "right-tapping") ||
     (getParameter("operation:cycleType") == "left-tapping") ||
     (getParameter("operation:cycleType") == "tapping-with-chip-breaking"));
  threading = hasParameter("operation:strategy") && (getParameter("operation:strategy") == "turningThread");

  var forceToolAndRetract = optionalSection && !currentSection.isOptional();
  optionalSection = currentSection.isOptional();
  bestABCIndex = undefined;

  machineState.isTurningOperation = (currentSection.getType() == TYPE_TURNING);
  if (machineState.isTurningOperation && gotBAxis) {
    bAxisOrientationTurning = getBAxisOrientationTurning(currentSection);
  }
  var insertToolCall = forceToolAndRetract || isFirstSection() || currentSection.isMultiAxis() ||
    currentSection.getForceToolChange && currentSection.getForceToolChange() ||
    (tool.number != getPreviousSection().getTool().number) ||
    (tool.compensationOffset != getPreviousSection().getTool().compensationOffset) ||
    (tool.diameterOffset != getPreviousSection().getTool().diameterOffset) ||
    (tool.lengthOffset != getPreviousSection().getTool().lengthOffset) || isNewSpindle;

  retracted = false; // specifies that the tool has been retracted to the safe plane
  
  var newWorkOffset = isFirstSection() ||
    (getPreviousSection().workOffset != currentSection.workOffset); // work offset changes
  var newWorkPlane = isFirstSection() ||
    !isSameDirection(getPreviousSection().getGlobalFinalToolAxis(), currentSection.getGlobalInitialToolAxis()) ||
    (machineState.isTurningOperation &&
      abcFormat.areDifferent(bAxisOrientationTurning.x, machineState.currentBAxisOrientationTurning.x) ||
      abcFormat.areDifferent(bAxisOrientationTurning.y, machineState.currentBAxisOrientationTurning.y) ||
      abcFormat.areDifferent(bAxisOrientationTurning.z, machineState.currentBAxisOrientationTurning.z));

  partCutoff = hasParameter("operation-strategy") &&
    (getParameter("operation-strategy") == "turningPart");


  updateMachiningMode(currentSection); // sets the needed machining mode to machineState (usePolarMode, useXZCMode, axialCenterDrilling)

  // Get the active spindle
  var newSpindle = true;
  var tempSpindle = getSpindle(false);
  if (isFirstSection()) {
    previousSpindle = tempSpindle;
  }
  newSpindle = tempSpindle != previousSpindle;
  // End the previous section if a new tool is selected

  if (insertToolCall || newSpindle || newWorkOffset || newWorkPlane) {
    if (G127isActive) {
  writeBlock(gFormat.format(126) + " (" + "DISABLE TILTED WORKPLANE" + ")");
  G127isActive = false;
  forceWorkPlane();
}
}
  if (!isFirstSection() && insertToolCall &&
      !(stockTransferIsActive && partCutoff)) {
        if (stockTransferIsActive) {
      if (!partWasCutOff) { //
        writeBlock(gFormat.format(144)); // Wait code to allow for tool Restart function on the machine.
      }
      writeBlock(mFormat.format(getCode("SPINDLE_SYNCHRONIZATION_OFF", getSpindle(true))), formatComment("SYNCHRONIZED ROTATION OFF"));
    } else {
      if (previousSpindle == SPINDLE_LIVE) {
        onCommand(COMMAND_STOP_SPINDLE);
        forceUnlockMultiAxis();
        if (tempSpindle != SPINDLE_LIVE) {
          if(!currentSection.isPatterned()){      
            writeRetract();
          }
          writeBlock(gPlaneModal.format(getCode("ENABLE_TURNING", getSpindle(true))));
        } else {
          onCommand(COMMAND_UNLOCK_MULTI_AXIS);
          if ((tempSpindle != SPINDLE_LIVE) && !properties.optimizeCaxisSelect) {
            cAxisEnableModal.reset();
            writeBlock(cAxisEnableModal.format(getCode("DISABLE_C_AXIS", getSpindle(true))));
          }
        }
      }
      setCoolant(COOLANT_OFF, machineState.currentTurret);
      /*
      // cancel SFM mode to preserve spindle speed
      if (getPreviousSection().getTool().getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
        var initialPosition = getCurrentPosition();
        var spindleDir = mFormat.format(getPreviousSection().getTool().clockwise ? getCode("START_SPINDLE_CW", getSpindle(false)) : getCode("START_SPINDLE_CCW", getSpindle(false)));
        writeBlock(
          gSpindleModeModal.format(getCode("CONSTANT_SURFACE_SPEED_OFF", getSpindle(false))),
          sOutput.format(Math.min((getPreviousSection().getTool().surfaceSpeed)/(Math.PI*initialPosition.x*2), properties.maximumSpindleSpeed))
          // spindleDir
        );
      }*/
    }
    // writeRetract();
    // writeRetract(X);
    // writeRetract(Z);

    // cancel tool length compensation
    if (!isFirstSection() && insertToolCall) {
      //writeBlock("T" + tool1Format.format(0 * 10000 + getPreviousSection().getTool().number * 100 + 0));
    }

    // mInterferModal.reset();
    // writeBlock(mInterferModal.format(getCode("INTERFERENCE_CHECK_OFF", getSpindle(true))));
  }
  // Consider part cutoff as stockTransfer operation
  if (!(stockTransferIsActive && partCutoff)) {
    stockTransferIsActive = false;
  }


  if (insertToolCall || newSpindle || newWorkOffset || newWorkPlane && !currentSection.isPatterned()) {
    // retract to safe plane
    if (!stockTransferIsActive) {

      writeRetract();

    }
    if (properties.optionalStop && !isFirstSection()) {
      onCommand(COMMAND_OPTIONAL_STOP);
      gMotionModal.reset();
    }
  }

  // Output the operation description
  writeln("");

  if (hasParameter("operation-comment")) {
    var comment = getParameter("operation-comment");
    if (comment) {
      if (!insertToolCall && properties.sequenceNumberToolOnly) {
        writeCommentSeqno(comment);
      } else {
        writeComment(comment);
      }
    }
  }

  /** Handle multiple turrets. */
  if (gotMultiTurret) {
    var turret = tool.turret;
    if (turret == 0) {
      warning(localize("Turret has not been specified. Using Turret 1 as default."));
      turret = 1; // upper turret as default
    }
    if (turret != machineState.currentTurret) {
      // change of turret
      writeBlock("N" + waitNumber + " P" + (waitNumber));
      waitNumber += 10;
      gSelectSpindleModal.reset();
      setCoolant(COOLANT_OFF, machineState.currentTurret);
        }
    switch (turret) {
      case 1:
        writeBlock(gFormat.format(13));
        break;
      case 2:
        writeBlock(gFormat.format(14));
        break;
      default:
        error(localize("Turret is not supported."));
        return;
    }
    machineState.currentTurret = turret;
  } else {
    machineState.currentTurret = 1;

  }

  if (insertToolCall) {
  writeBlock(mFormat.format(331)); // stop look ahead
  }

  // Select the active spindle
  if (properties.gotSecondarySpindle) {
    writeBlock(gSelectSpindleModal.format(getCode("SELECT_SPINDLE", getSpindle(true))));
  }





  if (false) { // TAG testing 270 271 272
    if (gotYAxis && (getSpindle(false) == SPINDLE_LIVE) && !machineState.usePolarMode && !machineState.useXZCMode) {
      writeBlock(gPolarModal.format(getCode("ENABLE_Y_AXIS", true)), "(Y AXIS MODE ON)");
      yOutput.enable();
    }
  }

  // Position all axes at home
  if (insertToolCall && !stockTransferIsActive) {
/*
    if (properties.gotSecondarySpindle) {
      writeBlock(gMotionModal.format(0), gFormat.format(28), gFormat.format(53), "B" + abcFormat.format(0)); // retract Sub Spindle if applicable
    }
*/
    // writeRetract();
    // writeRetract(X);
    // writeRetract(Z);

    // Stop the spindle
    if (newSpindle) {
      onCommand(COMMAND_STOP_SPINDLE);
    }
  }
  var wcsOut = "";
/*
  // Setup WCS code
  if (insertToolCall) { // force work offset when changing tool
    currentWorkOffset = undefined;
  }
  var workOffset = currentSection.workOffset;
  if (workOffset == 0) {
    warningOnce(localize("Work offset has not been specified. Using G54 as WCS."), WARNING_WORK_OFFSET);
    workOffset = 1;
  }
  var wcsOut = "";
  if (workOffset > 0) {
    if (workOffset > 6) {
         error(localize("Work offset out of range."));
        return;
    } else {
      if (workOffset != currentWorkOffset) {
        forceWorkPlane();
        wcsOut = gFormat.format(53 + workOffset); // G54->G59
        currentWorkOffset = workOffset;
      }
    }
  }
*/

  // Get active feedrate mode
  if (insertToolCall) {
    gFeedModeModal.reset();
  }
  var feedMode;
  if ((currentSection.feedMode == FEED_PER_REVOLUTION) || tapping || threading) {
    feedMode = gFeedModeModal.format(getCode("FEED_MODE_MM_REV", getSpindle(false)));
  } else {
    feedMode = gFeedModeModal.format(getCode("FEED_MODE_MM_MIN", getSpindle(false)));
  }

  // Live Spindle is active
  if (tempSpindle == SPINDLE_LIVE) {
    if (insertToolCall || wcsOut || feedMode) {
      forceUnlockMultiAxis();
      // onCommand(COMMAND_UNLOCK_MULTI_AXIS);
      var plane;
      switch (getMachiningDirection(currentSection)) {
      case MACHINING_DIRECTION_AXIAL:
        plane = getG17Code();
        break;
      case MACHINING_DIRECTION_RADIAL:
        plane = 19;
        break;
      case MACHINING_DIRECTION_INDEXING:
        plane = 17;
        break;
      default:
        error(subst(localize("Unsupported machining direction for operation " + "\"" + "%1" + "\"" + "."), getOperationComment()));
        return;
      }
      gPlaneModal.reset();
      if (!properties.optimizeCaxisSelect) {
        cAxisEnableModal.reset();
      }
      // writeBlock(wcsOut, mFormat.format(getCode("SET_SPINDLE_FRAME", getSpindle(true))));
      writeBlock(feedMode, gPlaneModal.format(plane), cAxisEnableModal.format(getCode("ENABLE_C_AXIS", getSpindle(true))));
      //writeBlock(gMotionModal.format(0), gFormat.format(28), "H" + abcFormat.format(0)); // unwind c-axis
      if (!machineState.usePolarMode && !machineState.useXZCMode && !currentSection.isMultiAxis()) {
        // onCommand(COMMAND_LOCK_MULTI_AXIS);
      }
    }

  // Turning is active
  } else {
    if ((insertToolCall || wcsOut || feedMode) && !stockTransferIsActive) {
      // forceUnlockMultiAxis();
      // writeBlock(cAxisEnableModal.format(getCode("UNLOCK_MULTI_AXIS", getSpindle(true))));
      gPlaneModal.reset();
      if (!properties.optimizeCaxisSelect) {
        cAxisEnableModal.reset();
      }
      // writeBlock(wcsOut, mFormat.format(getSpindle(true) == SPINDLE_SUB ? 83 : 80));
      writeBlock(gPlaneModal.format(getCode("ENABLE_TURNING", getSpindle(true))));
      writeBlock(feedMode, gPlaneModal.format(18));
    } else {
      writeBlock(feedMode);
    }
  }

  // Write out maximum spindle speed
  if (/*insertToolCall &&*/ !stockTransferIsActive) {
    if ((tool.maximumSpindleSpeed > 0) && (currentSection.getTool().getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED)) {
      var maximumSpindleSpeed = (tool.maximumSpindleSpeed > 0) ? Math.min(tool.maximumSpindleSpeed, properties.maximumSpindleSpeed) : properties.maximumSpindleSpeed;
      writeBlock(gFormat.format(50), sOutput.format(maximumSpindleSpeed));
      sOutput.reset();
      sbOutput.reset();
    }
  }

  // Write out notes
  if (properties.showNotes && hasParameter("notes")) {
    var notes = getParameter("notes");
    if (notes) {
      var lines = String(notes).split("\n");
      var r1 = new RegExp("^[\\s]+", "g");
      var r2 = new RegExp("[\\s]+$", "g");
      for (line in lines) {
        var comment = lines[line].replace(r1, "").replace(r2, "");
        if (comment) {
          writeComment(comment);
        }
      }
    }
  }
  
  var abc;
  if (machineConfiguration.isMultiAxisConfiguration()) {
    if (machineState.isTurningOperation) {
      if (gotBAxis) {
        cancelTransformation();
        // handle B-axis support for turning operations here
        abc = bAxisOrientationTurning;
        //setSpindleOrientationTurning();
      } else {
        abc = getWorkPlaneMachineABC(currentSection, currentSection.workPlane);
      }
    } else {
      if (currentSection.isMultiAxis()) {
        forceWorkPlane();
        cancelTransformation();
        writeBlock(cAxisEnableModal.format(getCode("ENABLE_C_AXIS", getSpindle(true))));
        abc = currentSection.getInitialToolAxisABC();
      } else {
        abc = getWorkPlaneMachineABC(currentSection, currentSection.workPlane);
      }
    }
  } else { // pure 3D
    var remaining = currentSection.workPlane;
    if (!isSameDirection(remaining.forward, new Vector(0, 0, 1))) {
      error(localize("Tool orientation is not supported by the CNC machine."));
      return;
    }
    setRotation(remaining);
  }
  
  if (insertToolCall) {
    if (!stockTransferIsActive) {
      writeRetract();
    }
    gPlaneModal.reset();
    forceWorkPlane();
    cAxisEngageModal.reset();
    setCoolant(COOLANT_OFF, machineState.currentTurret);

    var compensationOffset = tool.isTurningTool() ? tool.compensationOffset : tool.lengthOffset;
/*
    if (tool.compensationOffset > 96) {
      error(localize("Compensation offset is out of range."));
      return;
    }
    if (tool.lengthOffset > 96) {
      error(localize("Compensation offset is out of range."));
      return;
    }
    if (tool.number > properties.maxTool) {
      warning(localize("Tool number exceeds maximum value."));
    }
*/
    if (tool.number == 0) {
      error(localize("Tool number cannot be 0"));
      return;
    }

    gMotionModal.reset();
    if (properties.sequenceNumberToolOnly) {
      showSequenceNumbers = true;
    }

    // writeln((machineState.currentTurret == 1 ? "NA" : "NB") + toolFormat.format(tool.number));

    // TOOL CALL
    if (machineState.currentTurret == 1) {
      if (tool.isTurningTool()) {
        var angle = abcFormat.getResultingValue(getBAxisOrientationTurning(currentSection).y);
        var leftHand = false;
        // if (hasParameter("operation:tool_angle")) {
        //  angle = getParameter("operation:tool_angle");
        // }
        if (hasParameter("operation:tool_hand")) {
          if (getParameter("operation:tool_hand") == "L" || getParameter("operation:tool_hand") == "N") {
            leftHand = true;
          }
        }
        var orientationNumber;
        var found = true;
        if (currentSection.spindle == SPINDLE_PRIMARY) {
          switch (angle) {
            case 90:
              orientationNumber = leftHand ? 2 : 1;
              break;
            case 45:
              orientationNumber = leftHand ? 4 : 3;
              break;
            case 0:
              orientationNumber = leftHand ? 6 : 5;
              break;
            default:
              found = false;
          }
        } else if (properties.gotSecondarySpindle && currentSection.spindle == SPINDLE_SECONDARY) {
          switch (angle) {
            case 90:
              orientationNumber = leftHand ? 7 : 8;
              break;
            case 45:
              orientationNumber = leftHand ? 9 : 10;
              break;
            case 0:
              orientationNumber = leftHand ? 11 : 12;
              break;
            default:
              found = false;
          }
        }
        if (found) {
          writeBlock("TD=" + orientationNumberFormat.format(orientationNumber) + toolFormat.format(tool.number) + " M323");
        } else {
          writeBlock("TD=" + orientationNumberFormat.format(currentSection.spindle == SPINDLE_PRIMARY ? (leftHand ? 2 : 1) : (leftHand ? 7 : 8)) + toolFormat.format(tool.number) + " M323");
          writeBlock("BA=" + abcFormat.format(abc.y), gFormat.format(52));
        }
      } else { // milling
        // upper turret
        if (currentSection.spindle == SPINDLE_PRIMARY) {
          if (getMachiningDirection(currentSection) == MACHINING_DIRECTION_RADIAL && !currentSection.isMultiAxis()) {
            writeBlock("TD=05" + toolFormat.format(tool.number) + " M323");
          } else {
            writeBlock("TD=01" + toolFormat.format(tool.number) + " M323");
          }
        }
        if (properties.gotSecondarySpindle) {
          if (currentSection.spindle == SPINDLE_SECONDARY) {
            if (getMachiningDirection(currentSection) == MACHINING_DIRECTION_RADIAL && !currentSection.isMultiAxis()) {
              writeBlock("TD=11" + toolFormat.format(tool.number) + " M323");
            } else {
              writeBlock("TD=7" + toolFormat.format(tool.number) + " M323");
            }
          }
        }
      }
    } else {
      // lower turret
      if (currentSection.spindle == SPINDLE_PRIMARY) {
        writeBlock("TD=0101" + toolFormat.format(tool.number) + " M323");
      } else {
        writeBlock("TD=0207" + toolFormat.format(tool.number) + " M323");
      }
    }
    if (properties.CASOff) {
      writeBlock(mFormat.format(867));
    }
    if (!stockTransferIsActive) {
      writeRetract(); // TAG WHY IS THIS NEEDED?
    }

    if (tool.comment) {
      writeComment(tool.comment);
    }

    if (properties.preloadTool) { // only output next tool on B-axis turret
      if (machineState.currentTurret != 2) {
        var nextToolNumber = 0;
        for (var i = getCurrentSectionId() + 1; i < getNumberOfSections(); ++i) {
          var nextTool = getSection(i).getTool();
          if (tool.number != nextTool.number) {
            if (machineState.currentTurret != 2 && nextTool.turret != 2) {
              nextToolNumber = nextTool.number;
              break; // found
            }
          }
        }
        if (nextToolNumber && nextToolNumber != 0) {
          writeBlock("MT=" + toolFormat.format(nextToolNumber) + "01" + formatComment("NEXT TOOL"));
        } else {
          // preload first tool
          var lastToolOnUpperTurret = false;
          for (var i = getCurrentSectionId(); i < getNumberOfSections(); ++i) {
            if (getSection(i).getTool().turret == 0) {
              lastToolOnUpperTurret = true;
              break;
            }
          }
          if (lastToolOnUpperTurret) {
            for (var i = 0; i < getNumberOfSections(); ++i) {
              if (getSection(i).getTool().turret != 2) { // find first tool on B-axis turret
                var firstToolNumber = getSection(i).getTool().number;
                break; // found
              }
            }
            if (tool.number != firstToolNumber) {
            writeBlock("MT=" + toolFormat.format(firstToolNumber) + "01" + formatComment("FIRST TOOL"));
            }
          }
        }
      }
    }

/*
    0 Load monitoring OFF for all axes
    1 X-axis load monitoring ON
    2 Z-axis load monitoring ON
    4 C-axis load monitoring ON
    8 Spindle monitoring ON
    16 M-tool spindle monitoring ON
    32 W-axis monitoring ON
    64 Sub spindle monitoring ON
    128 Y-axis monitoring ON
    256 B-axis monitoring ON
    */
      var Strategy = hasParameter("operation:strategy") && getParameter("operation:strategy");
      var MonitTurning1 = 0;
      var MonitTurning2 = 0;
      switch(Strategy) {
      case "turningFace":
      case "turningProfileGroove":
      case "turningGroove":
      case "turningPart":
        MonitTurning1 = 1;
        break;
      case "turningRoughing":
      case "turningChamfer":
      case "turningThread":
        MonitTurning2 = 2;
        break;
      }
      var MonitCD = machineState.axialCenterDrilling ? 2 : 0;
      var MonitMill = ((currentSection.getType() == TYPE_MILLING) && !machineState.axialCenterDrilling) ? 19 : 0;
      //writeBlock("VLMON[" + (currentSection.getId() + 1) + "]=" + (MonitTurning1 + MonitTurning2 + MonitCD + MonitMill));

      gPlaneModal.reset();
    // Turn on coolant
    setCoolant(tool.coolant, machineState.currentTurret);

    // Disable/Enable Spindle C-axis switching
    // Machine does not support C-axis switching
    // It automatically performs this function when the secondary spindle is enabled
/*
    if (getSpindle(false) == SPINDLE_LIVE) {
      if (properties.gotSecondarySpindle) {
        switch (currentSection.spindle) {
        case SPINDLE_PRIMARY: // main spindle
          writeBlock(gSpindleModal.format(177));
          break;
        case SPINDLE_SECONDARY: // sub spindle
          writeBlock(gSpindleModal.format(176));
          break;
        }
      }
    }
*/
  }

  if (gotYAxis) {
      // activate Y-axis
    if ((getSpindle(false) == SPINDLE_LIVE) && !machineState.usePolarMode && !machineState.useXZCMode) {
      gPlaneModal.reset();
      if (insertToolCall) { // re-enable Y axis mode again if there is a tool change
        gPolarModal.reset();
      }
      var code = gPolarModal.format(getCode("ENABLE_Y_AXIS", true));
      var info = code ? "(Y AXIS MODE ON)" : "";
      writeBlock(code, info);
      yOutput.enable();
    } else {
      // deactivate Y-axis
      if (machineState.yAxisModeIsActive) {
        if (!retracted) {
          error(localize("Cannot disable Y axis mode while the machine is not fully retracted."));
          return;
        }
        writeBlock(gMotionModal.format(0), yOutput.format(0));
        onCommand(COMMAND_UNLOCK_MULTI_AXIS);
        var code = gPolarModal.format(getCode("DISABLE_Y_AXIS", true));
        var info = code ? "(Y AXIS MODE OFF)" : "";
        writeBlock(code, info);
        yOutput.disable();
      }
    }
  }
  // Activate part catcher for part cutoff section
  // if (properties.gotPartCatcher && partCutoff && currentSection.partCatcher) {
  //   engagePartCatcher(true);
  // }

  // command stop for manual tool change, useful for quick change live tools
  if (insertToolCall && tool.manualToolChange) {
    onCommand(COMMAND_STOP);
    writeBlock("(" + "MANUAL TOOL CHANGE TO T" + toolFormat.format(tool.number * 100 + compensationOffset) + ")");
  }

  // Engage tailstock
  if (properties.useTailStock) {
    if (machineState.axialCenterDrilling || (getSpindle(true) == SPINDLE_SUB) ||
       ((getSpindle(false) == SPINDLE_LIVE) && (getMachiningDirection(currentSection) == MACHINING_DIRECTION_AXIAL))) {
      if (currentSection.tailstock) {
        warning(localize("Tail stock is not supported for secondary spindle or Z-axis milling."));
      }
      if (machineState.tailstockIsActive) {
        writeBlock(tailStockModal.format(getCode("TAILSTOCK_OFF", SPINDLE_MAIN)));
      }
    } else {
      writeBlock(tailStockModal.format(currentSection.tailstock ? getCode("TAILSTOCK_ON", SPINDLE_MAIN) : getCode("TAILSTOCK_OFF", SPINDLE_MAIN)));
    }
  }

  // Output spindle codes
  if (newSpindle) {
    // select spindle if required
  }

  if ((insertToolCall ||
      newSpindle ||
      isFirstSection() ||
      (rpmFormat.areDifferent(tool.spindleRPM, currentRPM)) ||
      (tool.clockwise != getPreviousSection().getTool().clockwise)) &&
      !stockTransferIsActive) {
    currentRPM = tool.spindleRPM;
    if (machineState.isTurningOperation) {
      if (tool.spindleRPM > 3200) {
        warning(subst(localize("Spindle speed exceeds maximum value for operation \"%1\"."), getOperationComment()));
      }
    } else {
      if (tool.spindleRPM > 6000) {
        warning(subst(localize("Spindle speed exceeds maximum value for operation \"%1\"."), getOperationComment()));
      }
    }

    // Turn spindle on
    setSpindle(false, true, 0);
    if (HSSC) {
      writeBlock(mFormat.format(695));
    }
  }
  // var maxFeed = currentSection.getMaximumFeedrate();
  var maxFeed = 20000;

  if (!machineState.isTurningOperation && !machineState.axialCenterDrilling) {
    if (hasParameter("operation:tolerance")) {
      t = getParameter("operation:tolerance");
      var d = getParameter("operation:tolerance");
    } else {
      t = 0.01;
      machiningMode = 0;
      var d = 0.01;
    }
    if (hasParameter("operation:smoothingFilter") && getParameter("operation:smoothingFilter") == 1) {
      t = getParameter("operation:smoothingFilterTolerance");
      var d = getParameter("operation:smoothingFilterTolerance");
    }
    if (hasParameter("operation-strategy") && getParameter("operation-strategy") == "adaptive") {
      t = 0.1;
      if (hasParameter("operation:smoothingFilterTolerance") && getParameter("operation:smoothingFilterTolerance") != 0) {
        var d = getParameter("operation:smoothingFilterTolerance");
      } else {
        var d = getParameter("operation:tolerance");
      }
      machiningMode = 1;
    }
    if (currentSection.isMultiAxis()) {
      t = 0.01;
      var d = getParameter("operation:tolerance");
      machiningMode = 2;
    }
    if (t < 0.001) {
      t = 0.01;
      machiningMode = 1;
    }
    writeBlock(gFormat.format(265), "F" + spatialFormat.format(maxFeed), "E" + t, "J" + machiningMode, "D" + d);
  } else {
    writeBlock(gFormat.format(264));
  }
  // Turn off interference checking with secondary spindle
  if (getSpindle(true) == SPINDLE_SUB) {
    // writeBlock(mInterferModal.format(getCode("INTERFERENCE_CHECK_OFF", getSpindle(true))));
  }

  forceAny();
  gMotionModal.reset();

  if (currentSection.isMultiAxis()) {
    // writeBlock(gMotionModal.format(0), aOutput.format(abc.x), bOutput.format(abc.y), cOutput.format(abc.z));
    forceWorkPlane();
    cancelTransformation();
  } else {
    if (machineState.isTurningOperation || machineState.axialCenterDrilling) {
      if (gotBAxis) {
        // TAG: handle B-axis support for turning operations here
        // writeBlock(gMotionModal.format(0), conditional(machineConfiguration.isMachineCoordinate(1), "BA=" + abcFormat.format(getB(bAxisOrientationTurning, currentSection))));
        machineState.currentBAxisOrientationTurning = bAxisOrientationTurning;
        //setSpindleOrientationTurning();
      } else {
        setRotation(currentSection.workPlane);
      }
    } else {
      setWorkPlane(abc);
    }
  }
  forceAny();
  if (abc !== undefined) {
    cOutput.format(abc.z); // make C current - we do not want to output here
  }
  gMotionModal.reset();
  var initialPosition = getFramePosition(currentSection.getInitialPosition());

  if (currentSection.isMultiAxis()) {
    onCommand(COMMAND_UNLOCK_MULTI_AXIS);
    writeBlock(gFormat.format(99)); // turn off collision monitor
    writeBlock(gFormat.format(149) + " (B-AXIS MODE ON)");
    writeBlock(mFormat.format(331));
    writeBlock(mFormat.format(625)); // unclamp B
    if (properties.useM960) {
      writeBlock(mFormat.format(960));
    }
    forceABC();
    forceWorkPlane();
    cancelTransformation();
    writeBlock(gFormat.format(0), aOutput.format(abc.x), bOutput.format(abc.y), cOutput.format(abc.z));
    forceABC();
    writeBlock(
      gFormat.format(255), gMotionModal.format(0),
      xOutput.format(initialPosition.x), yOutput.format(initialPosition.y), zOutput.format(initialPosition.z),
      aOutput.format(abc.x), bOutput.format(abc.y), cOutput.format(abc.z),
      currentSection.spindle == SPINDLE_PRIMARY ? "TDS=01" : "TDS=07"
    );
  } else {
    if (insertToolCall || retracted || G127isActive) {
      gMotionModal.reset();
      if (machineState.useXZCMode || machineState.usePolarMode) {
        writeBlock(gPlaneModal.format(getG17Code()));
        setCAxisDirection(cOutput.getCurrent(), getC(initialPosition.x, initialPosition.y));
        writeBlock(gMotionModal.format(0), zOutput.format(initialPosition.z));
        writeBlock(
          gMotionModal.format(0),
          xOutput.format(getModulus(initialPosition.x, initialPosition.y)),
          conditional(gotYAxis, yOutput.format(0)),
          cOutput.format(getC(initialPosition.x, initialPosition.y))
        );
      } else {
        if (machineState.isTurningOperation) {
          writeBlock(gPlaneModal.format(18));
          writeBlock(gMotionModal.format(0), zOutput.format(initialPosition.z));
          writeBlock(gMotionModal.format(0), xOutput.format(initialPosition.x), yOutput.format(initialPosition.y));
        } else {
          // check for active G127 for XY, Z
          writeBlock(gPlaneModal.format(getG17Code()));
          if (G127isActive) {
            writeBlock(gMotionModal.format(0), xOutput.format(initialPosition.x), yOutput.format(initialPosition.y));
            writeBlock(gMotionModal.format(0), zOutput.format(initialPosition.z));
          } else if (getMachiningDirection(currentSection) == MACHINING_DIRECTION_INDEXING) {
            writeBlock(gMotionModal.format(0), xOutput.format(initialPosition.x), yOutput.format(initialPosition.y), zOutput.format(initialPosition.z));
          } else {
            writeBlock(gMotionModal.format(0), zOutput.format(initialPosition.z));
            writeBlock(gMotionModal.format(0), xOutput.format(initialPosition.x), yOutput.format(initialPosition.y));
          }
        }
      }
    }
  }

  // enable SFM spindle speed
  if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
    setSpindle(false, false);
  }

  if (machineState.usePolarMode) {
    setPolarMode(true); // enable polar interpolation mode
  }
  if (properties.useParametricFeed &&
      hasParameter("operation-strategy") &&
      (getParameter("operation-strategy") != "drill") && // legacy
      !(currentSection.hasAnyCycle && currentSection.hasAnyCycle())) {
    if (!insertToolCall &&
        activeMovements &&
        (getCurrentSectionId() > 0) &&
        ((getPreviousSection().getPatternId() == currentSection.getPatternId()) && (currentSection.getPatternId() != 0))) {
      // use the current feeds
    } else {
      initializeActiveFeeds();
    }
  } else {
    activeMovements = undefined;
  }
  
  previousSpindle = tempSpindle;
  activeSpindle = tempSpindle;

  if (false) { // DEBUG
    for (var key in machineState) {
      writeComment(key + " : " + machineState[key]);
    }
    writeComment("Tapping = " + tapping);
    // writeln("(" + (getMachineConfigurationAsText(machineConfiguration)) + ")");
  }
  retracted = false; // specifies that the tool has been retracted to the safe plane
  gPlaneModal.reset();
  isNewSpindle = false;
}

/** Returns true if the toolpath fits within the machine XY limits for the given C orientation. */
function doesToolpathFitInXYRange(abc) {
  var c = 0;
  if (abc) {
    c = abc.z;
  }

  var dx = new Vector(Math.cos(c), Math.sin(c), 0);
  var dy = new Vector(Math.cos(c + Math.PI/2), Math.sin(c + Math.PI/2), 0);

  if (currentSection.getGlobalRange) {
    var xRange = currentSection.getGlobalRange(dx);
    var yRange = currentSection.getGlobalRange(dy);

    if (false) { // DEBUG
      writeComment(
        "toolpath X minimum= " + xFormat.format(xRange[0]) + ", " + "Limit= " + xFormat.format(xAxisMinimum) + ", " +
        "within range= " + (xFormat.getResultingValue(xRange[0]) >= xFormat.getResultingValue(xAxisMinimum))
      );
      writeComment(
        "toolpath Y minimum= " + spatialFormat.getResultingValue(yRange[0]) + ", " + "Limit= " + yAxisMinimum + ", " +
        "within range= " + (spatialFormat.getResultingValue(yRange[0]) >= yAxisMinimum)
      );
      writeComment(
        "toolpath Y maximum= " + (spatialFormat.getResultingValue(yRange[1]) + ", " + "Limit= " + yAxisMaximum) + ", " +
        "within range= " + (spatialFormat.getResultingValue(yRange[1]) <= yAxisMaximum)
      );
      writeln("");
    }

    if (getMachiningDirection(currentSection) == MACHINING_DIRECTION_RADIAL) { // G19 plane
      if ((spatialFormat.getResultingValue(yRange[0]) >= yAxisMinimum) &&
          (spatialFormat.getResultingValue(yRange[1]) <= yAxisMaximum)) {
        return true; // toolpath does fit in XY range
      } else {
        return false; // toolpath does not fit in XY range
      }
    } else { // G17 plane
      if ((xFormat.getResultingValue(xRange[0]) >= xFormat.getResultingValue(xAxisMinimum)) &&
          (spatialFormat.getResultingValue(yRange[0]) >= yAxisMinimum) &&
          (spatialFormat.getResultingValue(yRange[1]) <= yAxisMaximum)) {
        return true; // toolpath does fit in XY range
      } else {
        return false; // toolpath does not fit in XY range
      }
    }
  } else {
    if (revision < 40000) {
      warning(localize("Please update to the latest release to allow XY linear interpolation instead of polar interpolation."));
    }
    return false; // for older versions without the getGlobalRange() function
  }
}

var MACHINING_DIRECTION_AXIAL = 0;
var MACHINING_DIRECTION_RADIAL = 1;
var MACHINING_DIRECTION_INDEXING = 2;

function getMachiningDirection(section) {
  var forward = section.isMultiAxis() ? section.getGlobalInitialToolAxis() : section.workPlane.forward;
  if (isSameDirection(forward, new Vector(0, 0, 1))) {
    machineState.machiningDirection = MACHINING_DIRECTION_AXIAL;
    return MACHINING_DIRECTION_AXIAL;
  } else if (Vector.dot(forward, new Vector(0, 0, 1)) < 1e-7) {
    machineState.machiningDirection = MACHINING_DIRECTION_RADIAL;
    return MACHINING_DIRECTION_RADIAL;
  } else {
    machineState.machiningDirection = MACHINING_DIRECTION_INDEXING;
    return MACHINING_DIRECTION_INDEXING;
  }
}

function updateMachiningMode(section) {
  machineState.axialCenterDrilling = false; // reset
  machineState.usePolarMode = false; // reset
  machineState.useXZCMode = false; // reset

  if ((section.getType() == TYPE_MILLING) && !section.isMultiAxis()) {
    if (getMachiningDirection(section) == MACHINING_DIRECTION_AXIAL) {
      if (section.hasParameter("operation-strategy") && (section.getParameter("operation-strategy") == "drill")) {
        // drilling axial
        if ((section.getNumberOfCyclePoints() == 1) &&
            !xFormat.isSignificant(getGlobalPosition(section.getInitialPosition()).x) &&
            !yFormat.isSignificant(getGlobalPosition(section.getInitialPosition()).y) &&
            (spatialFormat.format(section.getFinalPosition().x) == 0) &&
            !doesCannedCycleIncludeYAxisMotion()) { // catch drill issue for old versions
          // single hole on XY center
          if (section.getTool().isLiveTool && section.getTool().isLiveTool()) {
            // use live tool
          } else {
            // use main spindle for axialCenterDrilling
            machineState.axialCenterDrilling = true;
            warning(localize("AxialCenterDrilling"));
          }
        } else {
          // several holes not on XY center, use live tool in XZCMode
          machineState.useXZCMode = true;
        }
      } else { // milling
        if (forcePolarMode) {
          machineState.usePolarMode = true;
        } else if (forceXZCMode) {
          machineState.useXZCMode = true;
        } else {
          fitFlag = false;
          bestABCIndex = undefined;
          for (var i = 0; i < 6; ++i) {
            fitFlag = doesToolpathFitInXYRange(getBestABC(section, section.workPlane, i));
            if (fitFlag) {
              bestABCIndex = i;
              break;
            }
          }
          if (!fitFlag) { // does not fit, set polar/XZC mode
            if (gotPolarInterpolation) {
              machineState.usePolarMode = true;
            } else {
              machineState.useXZCMode = true;
            }
          }
        }
      }
    } else if (getMachiningDirection(section) == MACHINING_DIRECTION_RADIAL) { // G19 plane
      if (!gotYAxis) {
        if (!section.isMultiAxis() && !doesToolpathFitInXYRange(machineConfiguration.getABC(section.workPlane)) && doesCannedCycleIncludeYAxisMotion()) {
          error(subst(localize("Y-axis motion is not possible without a Y-axis for operation \"%1\"."), getOperationComment()));
          return;
        }
      } else {
        if (!doesToolpathFitInXYRange(machineConfiguration.getABC(section.workPlane)) || forceXZCMode) {
          error(subst(localize("Toolpath exceeds the maximum ranges for operation \"%1\"."), getOperationComment()));
          return;
        }
      }
      // C-coordinates come from setWorkPlane or is within a multi axis operation, we cannot use the C-axis for non wrapped toolpathes (only multiaxis works, all others have to be into XY range)
    } else {
      // useXZCMode & usePolarMode is only supported for axial machining, keep false
    }
  } else {
    // turning or multi axis, keep false
  }

  if (machineState.axialCenterDrilling) {
    cOutput.disable();
  } else {
    cOutput.enable();
  }

  var checksum = 0;
  checksum += machineState.usePolarMode ? 1 : 0;
  checksum += machineState.useXZCMode ? 1 : 0;
  checksum += machineState.axialCenterDrilling ? 1 : 0;
  validate(checksum <= 1, localize("Internal post processor error."));
}

function doesCannedCycleIncludeYAxisMotion() {
  // these cycles have Y axis motions which are not detected by getGlobalRange()
  var hasYMotion = false;
  if (hasParameter("operation:strategy") && (getParameter("operation:strategy") == "drill")) {
    switch (getParameter("operation:cycleType")) {
    case "thread-milling":
    case "bore-milling":
    case "circular-pocket-milling":
      hasYMotion = true; // toolpath includes Y-axis motion
      break;
    case "back-boring":
    case "fine-boring":
      var shift = getParameter("operation:boringShift");
      if (shift != spatialFormat.format(0)) {
        hasYMotion = true; // toolpath includes Y-axis motion
      }
      break;
    default:
      hasYMotion = false; // all other cycles don´t have Y-axis motion
    }
  } else {
    hasYMotion = true;
  }
  return hasYMotion;
}

function getOperationComment() {
  var operationComment = hasParameter("operation-comment") && getParameter("operation-comment");
  return operationComment;
}

function setRadiusDiameterMode(mode) {
  if (mode == "diameter") {
    xFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:false, scale:2}); // diameter mode
    xOutput = createVariable({prefix:"X"}, xFormat);
  } else {
    xFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:false, scale:1}); // radius mode
    xOutput = createVariable({prefix:"X"}, xFormat);
  }
}

function setPolarMode(activate) {
  if (activate) {
    setCAxisDirection(cOutput.getCurrent(), 0);
    cOutput.enable();
    cOutput.reset();
    writeBlock(gPolarModal.format(getCode("POLAR_INTERPOLATION_ON", getSpindle(false))), cOutput.format(0)); // command for polar interpolation
    writeBlock(gPlaneModal.format(17));
    yOutput = createVariable({prefix:"Y"}, yFormat);
    yOutput.enable(); // required for G12.1
    cOutput.disable();
    setRadiusDiameterMode("radius");
  } else {
    writeBlock(gPolarModal.format(getCode("POLAR_INTERPOLATION_OFF", getSpindle(false))));
    yOutput = createVariable({prefix:"Y"}, yFormat);
    yOutput.disable();
    cOutput.enable();
    setRadiusDiameterMode("diameter");
  }
}

function onDwell(seconds) {
  if (seconds > 9999.99) {
    warning(localize("Dwelling time is out of range."));
  }
  writeBlock(gFormat.format(4), dwellOutput.format(seconds));
}

var pendingRadiusCompensation = -1;

function onRadiusCompensation() {
  pendingRadiusCompensation = radiusCompensation;
}

var resetFeed = false;

function getHighfeedrate(radius) {
  if (currentSection.feedMode == FEED_PER_REVOLUTION) {
    if (toDeg(radius) <= 0) {
      radius = toPreciseUnit(0.1, MM);
    }
    var rpm = tool.spindleRPM; // rev/min
    if (currentSection.getTool().getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
      var O = 2 * Math.PI * radius; // in/rev
      rpm = tool.surfaceSpeed/O; // in/min div in/rev => rev/min
    }
    return highFeedrate/rpm; // in/min div rev/min => in/rev
  }
  return highFeedrate;
}

function onRapid(_x, _y, _z) {
  if (machineState.useXZCMode) {
    if (cycleExpanded == true && !isFirstCyclePoint()) {
      onCommand(COMMAND_UNLOCK_MULTI_AXIS); // unlock for expanded cycles
    }
    var start = getCurrentPosition();
    var dxy = getModulus(_x - start.x, _y - start.y);
    if (true || (dxy < getTolerance())) {
      var x = xOutput.format(getModulus(_x, _y));
      var c = cOutput.format(getCClosest(_x, _y, cOutput.getCurrent()));
      var z = zOutput.format(_z);
      if (pendingRadiusCompensation >= 0) {
        error(localize("Radius compensation mode cannot be changed at rapid traversal."));
        return;
      }
      setCAxisDirection(cOutput.getCurrent(), c);
      writeBlock(gMotionModal.format(0), x, c, z);
      forceFeed();
      return;
    }

    onLinear(_x, _y, _z, highFeedrate);
    return;
  }

  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  if (x || y || z) {
    var useG1 = (((x ? 1 : 0) + (y ? 1 : 0) + (z ? 1 : 0)) > 1) || machineState.usePolarMode;
    var highFeed = machineState.usePolarMode ? toPreciseUnit(1500, MM) : getHighfeedrate(_x);
    if (pendingRadiusCompensation >= 0) {
      pendingRadiusCompensation = -1;
      if (useG1) {
        switch (radiusCompensation) {
        case RADIUS_COMPENSATION_LEFT:
          writeBlock(gMotionModal.format(1), gFormat.format(41), x, y, z, getFeed(highFeed));
          break;
        case RADIUS_COMPENSATION_RIGHT:
          writeBlock(gMotionModal.format(1), gFormat.format(42), x, y, z, getFeed(highFeed));
          break;
        default:
          writeBlock(gMotionModal.format(1), gFormat.format(40), x, y, z, getFeed(highFeed));
        }
      } else {
        switch (radiusCompensation) {
        case RADIUS_COMPENSATION_LEFT:
          writeBlock(gMotionModal.format(0), gFormat.format(41), x, y, z);
          break;
        case RADIUS_COMPENSATION_RIGHT:
          writeBlock(gMotionModal.format(0), gFormat.format(42), x, y, z);
          break;
        default:
          writeBlock(gMotionModal.format(0), gFormat.format(40), x, y, z);
        }
      }
    }
    if (useG1) {
      // axes are not synchronized
      writeBlock(gMotionModal.format(1), x, y, z, getFeed(highFeed));
      resetFeed = false;
    } else {
      writeBlock(gMotionModal.format(0), x, y, z);
      // forceFeed();
    }
  }
}

/** Returns the U-coordinate along the 2D line for the projection of point p. */
function getLineProjectionU(start, end, p) {
  var ax = p.x - start.x;
  var ay = p.y - start.y;
  var deltax = end.x - start.x;
  var deltay = end.y - start.y;
  var squareModulus = deltax * deltax + deltay * deltay;
  var d = ax * deltax + ay * deltay; // dot
  return (squareModulus > 0) ? d/squareModulus : 0;
}

function onLinear(_x, _y, _z, feed) {
  if (machineState.useXZCMode) {
    if (cycleExpanded == true && !isFirstCyclePoint()) {
      onCommand(COMMAND_LOCK_MULTI_AXIS); // unlock for expanded cycles
    }
    if (maximumCircularSweep > toRad(179)) {
      error(localize("Maximum circular sweep must be below 179 degrees."));
      return;
    }
    
    var compCode = undefined;
    if (pendingRadiusCompensation >= 0) {
      pendingRadiusCompensation = -1;
      switch (radiusCompensation) {
      case RADIUS_COMPENSATION_LEFT:
        compCode = gFormat.format(41);
        break;
      case RADIUS_COMPENSATION_RIGHT:
        compCode = gFormat.format(42);
        break;
      default:
        compCode = gFormat.format(40);
      }
    }

    if (linearizeXZCMode) {
      var localTolerance = getTolerance()/2;
      var startXYZ = getCurrentPosition();
      var endXYZ = new Vector(_x, _y, _z);
      var splitXYZ = endXYZ;

      // check if we should split line segment at the closest point to the rotary
      var split = false;
      var rotaryXYZ = new Vector(0, 0, 0);
      var pu = getLineProjectionU(startXYZ, endXYZ, rotaryXYZ); // from rotary
      if ((pu > 0) && (pu < 1)) { // within segment start->end
        var p = Vector.lerp(startXYZ, endXYZ, pu);
        var d = Math.sqrt(sqr(p.x - rotaryXYZ.x) + sqr(p.y - rotaryXYZ.y)); // distance to rotary
        if (d < toPreciseUnit(0.1, MM)) { // we get very close to rotary
          split = true;
          var lminor = Math.sqrt(sqr(p.x - startXYZ.x) + sqr(p.y - startXYZ.y));
          var lmajor = Math.sqrt(sqr(endXYZ.x - startXYZ.x) + sqr(endXYZ.y - startXYZ.y));
          splitXYZ = new Vector(p.x, p.y, startXYZ.z + (endXYZ.z - startXYZ.z) * lminor/lmajor);
        }
      }

      var currentXYZ = splitXYZ;
      var turnFirst = false;

      while (false) { // repeat if we need to split
        var radius = Math.min(getModulus(startXYZ.x, startXYZ.y), getModulus(currentXYZ.x, currentXYZ.y));
        var radial = !xFormat.isSignificant(radius); // used to avoid noice in C-axis
        var length = Vector.diff(startXYZ, currentXYZ).length; // could measure in XY only
        // we cannot control feed of C-axis so we have to force small steps
        var numberOfSegments = Math.max(Math.ceil(length/toPreciseUnit(0.05, MM)), 1);

        var cc = getCClosest(currentXYZ.x, currentXYZ.y, cOutput.getCurrent());
        if (radial && (currentXYZ.x == 0) && (currentXYZ.y == 0)) {
          cc = getCClosest(startXYZ.x, startXYZ.y, cOutput.getCurrent());
        }
        var sweep = Math.abs(cc - cOutput.getCurrent()); // dont care for radial
        if (radius > localTolerance) {
          var stepAngle = 2 * Math.acos(1 - localTolerance/radius);
          numberOfSegments = Math.max(Math.ceil(sweep/stepAngle), numberOfSegments);
        }
        if (radial || !abcFormat.areDifferent(cc, cOutput.getCurrent())) {
          numberOfSegments = 1; // avoid linearization if there is no turn
        }

        for (var i = 1; i <= numberOfSegments; ++i) {
          var previousC = cOutput.getCurrent();
          var currentC = radial ? cc : getCClosest(p.x, p.y, cOutput.getCurrent());
          var p = Vector.lerp(startXYZ, currentXYZ, i * 1.0/numberOfSegments);
          var c = cOutput.format(currentC);
          if (c && turnFirst) { // turn before moving along X after rotary has been reached
            turnFirst = false;
            setCAxisDirection(previousC, c);
            writeBlock(compCode, gMotionModal.format(101), c, getFeed(feed));
            c = undefined; // dont output again
            compCode = undefined;
          }
          if (c != undefined) {
            setCAxisDirection(cOutput.getCurrent(), c);
          }
          writeBlock(compCode, gMotionModal.format(101), xOutput.format(getModulus(p.x, p.y)), c, zOutput.format(p.z), getFeed(feed));
          compCode = undefined;
        }

        if (!split) {
          break;
        }

        startXYZ = splitXYZ;
        currentXYZ = endXYZ;
        // writeComment("XC: restart at rotary");
        split = false;
        turnFirst = true;
      }
    } else {
      var currentC = getCClosest(_x, _y, cOutput.getCurrent());
      setCAxisDirection(cOutput.getCurrent(), currentC);
      writeBlock(compCode, gMotionModal.format(101), xOutput.format(getModulus(_x, _y)), cOutput.format(currentC), zOutput.format(_z), getFeed(feed));
      compCode = undefined;
    }
    return;
  }

  if (isSpeedFeedSynchronizationActive()) {
    resetFeed = true;
    var threadPitch = getParameter("operation:threadPitch");
    var threadsPerInch = 1.0/threadPitch; // per mm for metric
    var startXYZ = getCurrentPosition();
    var deltaX = spatialFormat.getResultingValue(_x - startXYZ.x);
    writeBlock(
      gMotionModal.format(31),
      xOutput.format(_x),
      yOutput.format(_y),
      zOutput.format(_z),
      iOutput.format(deltaX, 0),
      pitchOutput.format(1/threadsPerInch)
    );
    return;
  }
  if (resetFeed) {
    resetFeed = false;
    forceFeed();
  }
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var f = getFeed(feed);

  var linearCode = 1;
  if (machineState.usePolarMode && (x || y)) {
    linearCode = 101;
  }
  if (x || y || z) {
    if (false) { // TESTING ONLY, not proven, DANGER !!!
      if (movement == MOVEMENT_LINK_DIRECT) {
        if (machineState.usePolarMode || machineState.useXZCMode || machineState.isTurningOperation) {
          error(localize("POST ERROR"));
          return;
        }
        var startXYZ = getCurrentPosition();
        var endXYZ = new Vector(_x, _y, _z);
        var length = Vector.diff(startXYZ, endXYZ).length;
        var numberOfSegments = Math.max(Math.ceil(length / toPreciseUnit(0.5, MM)), 1);
        var localTolerance = getTolerance() / 2;
        for (var i = 1; i <= numberOfSegments; ++i) {
          var p = Vector.lerp(startXYZ, endXYZ, i * 1.0 / numberOfSegments);
          writeBlock(gMotionModal.format(linearCode), xOutput.format(p.x), yOutput.format(p.y), zOutput.format(p.z), f);
        }
        return;
      }
    }
    if (pendingRadiusCompensation >= 0) {
      pendingRadiusCompensation = -1;
      if (machineState.isTurningOperation) {
        writeBlock(gPlaneModal.format(18));
      } else if (isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, 1))) {
        writeBlock(gPlaneModal.format(getG17Code()));
      }
      switch (radiusCompensation) {
      case RADIUS_COMPENSATION_LEFT:
        writeBlock(gPlaneModal.format(getG17Code()));
        writeBlock(gMotionModal.format(linearCode), gFormat.format(41), x, y, z, f);
        break;
      case RADIUS_COMPENSATION_RIGHT:
        writeBlock(gPlaneModal.format(getG17Code()));
        writeBlock(gMotionModal.format(linearCode), gFormat.format(42), x, y, z, f);
        break;
      default:
        writeBlock(gMotionModal.format(linearCode), gFormat.format(40), x, y, z, f);
      }
    } else {
      writeBlock(gMotionModal.format(linearCode), x, y, z, f);
    }
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      forceFeed(); // force feed on next line
    } else {
      writeBlock(gMotionModal.format(linearCode), f);
    }
  }
}

function onRapid5D(_x, _y, _z, _a, _b, _c) {
  if (!currentSection.isOptimizedForMachine()) {
    error(localize("Multi-axis motion is not supported for XZC mode."));
    return;
  }
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation mode cannot be changed at rapid traversal."));
    return;
  }

  setCAxisDirection(cOutput.getCurrent(), _c);

  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var a = aOutput.format(_a);
  var b = bOutput.format(_b);
  var c = cOutput.format(_c);
  if (true) {
    // axes are not synchronized
    writeBlock(gMotionModal.format(1), x, y, z, a, b, c, getFeed(highFeedrate));
  } else {
    writeBlock(gMotionModal.format(0), x, y, z, a, b, c);
    forceFeed();
  }
}

function onLinear5D(_x, _y, _z, _a, _b, _c, feed) {
  if (!currentSection.isOptimizedForMachine()) {
    error(localize("Multi-axis motion is not supported for XZC mode."));
    return;
  }
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for 5-axis move."));
    return;
  }

  setCAxisDirection(cOutput.getCurrent(), _c);

  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var a = aOutput.format(_a);
  var b = bOutput.format(_b);
  var c = cOutput.format(_c);
  var f = getFeed(feed);

  if (x || y || z || a || b || c) {
    writeBlock(gMotionModal.format(1), x, y, z, a, b, c, f);
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      forceFeed(); // force feed on next line
    } else {
      writeBlock(gMotionModal.format(1), f);
    }
  }
}

// Start of onRewindMachine logic
/***** Be sure to add 'safeRetractDistance' to post properties. *****/
var performRewinds = true; // enables the onRewindMachine logic
var safeRetractFeed = (unit == IN) ? 20 : 500;
var safePlungeFeed = (unit == IN) ? 10 : 250;
var stockAllowance = (unit == IN) ? 0.1 : 2.5;

/** Allow user to override the onRewind logic. */
function onRewindMachineEntry(_a, _b, _c) {
  return false;
}

/** Retract to safe position before indexing rotaries. */
function moveToSafeRetractPosition(isRetracted) {
  if (!isRetracted) {
    writeRetract(); // use G20 HPxx
    // writeRetract(Z); // use G0 Z + properties home position Z
    zOutput.reset();
  }
  if (false) { // e.g. when machining very big parts
    writeRetract(X, Y);
    xOutput.reset();
    yOutput.reset();
  }
}

/** Return from safe position after indexing rotaries. */
function returnFromSafeRetractPosition(position) {
  forceXYZ();
  xOutput.reset();
  yOutput.reset();
  zOutput.disable();
  onRapid(position.x, position.y, position.z);
  zOutput.enable();
  onRapid(position.x, position.y, position.z);
}

/** Determine if a point is on the correct side of a box side. */
function isPointInBoxSide(point, side) {
  var inBox = false;
  switch (side.side) {
  case "-X":
    if (point.x >= side.distance) {
      inBox = true;
    }
    break;
  case "-Y":
    if (point.y >= side.distance) {
      inBox = true;
    }
    break;
  case "-Z":
    if (point.z >= side.distance) {
      inBox = true;
    }
    break;
  case "X":
    if (point.x <= side.distance) {
      inBox = true;
    }
    break;
  case "Y":
    if (point.y <= side.distance) {
      inBox = true;
    }
    break;
  case "Z":
    if (point.z <= side.distance) {
      inBox = true;
    }
    break;
  }
  return inBox;
}

/** Intersect a point-vector with a plane. */
function intersectPlane(point, direction, plane) {
  var normal = new Vector(plane.x, plane.y, plane.z);
  var cosa = Vector.dot(normal, direction);
  if (Math.abs(cosa) <= 1.0e-6) {
    return undefined;
  }
  var distance = (Vector.dot(normal, point) - plane.distance) / cosa;
  var intersection = Vector.diff(point, Vector.product(direction, distance));
  
  if (!isSameDirection(Vector.diff(intersection, point).getNormalized(), direction)) {
    return undefined;
  }
  return intersection;
}

/** Intersect the point-vector with the stock box. */
function intersectStock(point, direction) {
  var stock = getWorkpiece();
  var sides = new Array(
    {x:1, y:0, z:0, distance:stock.lower.x, side:"-X"},
    {x:0, y:1, z:0, distance:stock.lower.y, side:"-Y"},
    {x:0, y:0, z:1, distance:stock.lower.z, side:"-Z"},
    {x:1, y:0, z:0, distance:stock.upper.x, side:"X"},
    {x:0, y:1, z:0, distance:stock.upper.y, side:"Y"},
    {x:0, y:0, z:1, distance:stock.upper.z, side:"Z"}
  );
  var intersection = undefined;
  var currentDistance = 999999.0;
  var localExpansion = -stockAllowance;
  for (var i = 0; i < sides.length; ++i) {
    if (i == 3) {
      localExpansion = -localExpansion;
    }
    if (isPointInBoxSide(point, sides[i])) { // only consider points within stock box
      var location = intersectPlane(point, direction, sides[i]);
      if (location != undefined) {
        if ((Vector.diff(point, location).length < currentDistance) || currentDistance == 0) {
          intersection = location;
          currentDistance = Vector.diff(point, location).length;
        }
      }
    }
  }
  return intersection;
}

/** Calculates the retract point using the stock box and safe retract distance. */
function getRetractPosition(currentPosition, currentDirection) {
  var retractPos = intersectStock(currentPosition, currentDirection);
  if (retractPos == undefined) {
    if (tool.getFluteLength() != 0) {
      retractPos = Vector.sum(currentPosition, Vector.product(currentDirection, tool.getFluteLength()));
    }
  }
  if ((retractPos != undefined) && properties.safeRetractDistance) {
    retractPos = Vector.sum(retractPos, Vector.product(currentDirection, properties.safeRetractDistance));
  }
  return retractPos;
}

/** Determines if the angle passed to onRewindMachine is a valid starting position. */
function isRewindAngleValid(_a, _b, _c) {
  // make sure the angles are different from the last output angles
  if (!abcFormat.areDifferent(getCurrentDirection().x, _a) &&
      !abcFormat.areDifferent(getCurrentDirection().y, _b) &&
      !abcFormat.areDifferent(getCurrentDirection().z, _c)) {
    error(
      localize("REWIND: Rewind angles are the same as the previous angles: ") +
      abcFormat.format(_a) + ", " + abcFormat.format(_b) + ", " + abcFormat.format(_c)
    );
    return false;
  }
  
  // make sure angles are within the limits of the machine
  var abc = new Array(_a, _b, _c);
  var ix = machineConfiguration.getAxisU().getCoordinate();
  var failed = false;
  if ((ix != -1) && !machineConfiguration.getAxisU().isSupported(abc[ix])) {
    failed = true;
  }
  ix = machineConfiguration.getAxisV().getCoordinate();
  if ((ix != -1) && !machineConfiguration.getAxisV().isSupported(abc[ix])) {
    failed = true;
  }
  ix = machineConfiguration.getAxisW().getCoordinate();
  if ((ix != -1) && !machineConfiguration.getAxisW().isSupported(abc[ix])) {
    failed = true;
  }
  if (failed) {
    error(
      localize("REWIND: Rewind angles are outside the limits of the machine: ") +
      abcFormat.format(_a) + ", " + abcFormat.format(_b) + ", " + abcFormat.format(_c)
    );
    return false;
  }
  
  return true;
}

function onRewindMachine(_a, _b, _c) {
  
  if (!performRewinds) {
    error(localize("REWIND: Rewind of machine is required for simultaneous multi-axis toolpath and has been disabled."));
    return;
  }
  
  // Allow user to override rewind logic
  if (onRewindMachineEntry(_a, _b, _c)) {
    return;
  }
  
  // Determine if input angles are valid or will cause a crash
  if (!isRewindAngleValid(_a, _b, _c)) {
    error(
      localize("REWIND: Rewind angles are invalid:") +
      abcFormat.format(_a) + ", " + abcFormat.format(_b) + ", " + abcFormat.format(_c)
    );
    return;
  }
  
  // Work with the tool end point
  if (currentSection.getOptimizedTCPMode() == 0) {
    currentTool = getCurrentPosition();
  } else {
    currentTool = machineConfiguration.getOrientation(getCurrentDirection()).multiply(getCurrentPosition());
  }
  var currentABC = getCurrentDirection();
  var currentDirection = machineConfiguration.getDirection(currentABC);
  
  // Calculate the retract position
  var retractPosition = getRetractPosition(currentTool, currentDirection);

  // Output warning that axes take longest route
  if (retractPosition == undefined) {
    error(localize("REWIND: Cannot calculate retract position."));
    return;
  } else {
    var text = localize("REWIND: Tool is retracting due to rotary axes limits.");
    warning(text);
    writeComment(text);
  }

  // Move to retract position
  var position;
  if (currentSection.getOptimizedTCPMode() == 0) {
    position = retractPosition;
  } else {
    position = machineConfiguration.getOrientation(getCurrentDirection()).getTransposed().multiply(retractPosition);
  }
  if (_b != 0) {
    onLinear(position.x, position.y, position.z, safeRetractFeed);

    //Position to safe machine position for rewinding axes
    moveToSafeRetractPosition(false);
  }
  // Rotate axes to new position above reentry position
  xOutput.disable();
  yOutput.disable();
  zOutput.disable();
  onRapid5D(position.x, position.y, position.z, _a, _b, _c);
  xOutput.enable();
  yOutput.enable();
  zOutput.enable();

  // Move back to position above part
  if (currentSection.getOptimizedTCPMode() != 0) {
    position = machineConfiguration.getOrientation(new Vector(_a, _b, _c)).getTransposed().multiply(retractPosition);
  }
  if (_b != 0) {
    returnFromSafeRetractPosition(position);

    // Plunge tool back to original position
    if (currentSection.getOptimizedTCPMode() != 0) {
      currentTool = machineConfiguration.getOrientation(new Vector(_a, _b, _c)).getTransposed().multiply(currentTool);
    }
    onLinear(currentTool.x, currentTool.y, currentTool.z, safePlungeFeed);
  }
}
// End of onRewindMachine logic


function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  var directionCode = clockwise ? 2 : 3;
  directionCode += (machineState.useXZCMode || machineState.usePolarMode) ? 100 : 0;
  if (machineState.useXZCMode) {
    switch (getCircularPlane()) {
    case PLANE_XY:
      var d2 = center.x * center.x + center.y * center.y;
      if (!isHelical()) { // d2 < 1e-18) { // center is on rotary axis
        var currentC = getCClosest(x, y, cOutput.getCurrent(), clockwise);
        setCAxisDirection(cOutput.getCurrent(), currentC);
        writeBlock(
          gMotionModal.format(directionCode),
          xOutput.format(getModulus(x, y)),
          cOutput.format(currentC),
          "L" + rFormat.format(getCircularRadius()),
          getFeed(feed)
        );
        return;
      }
      break;
    }
    
    linearize(getTolerance());
    return;
  }
/*
  if (getSpindle(false) == SPINDLE_LIVE) {
    if (getMachiningDirection(currentSection) == MACHINING_DIRECTION_AXIAL) {
      if (getCircularPlane() != PLANE_XY) {
        linearize(getTolerance());
        return;
      }
    } else {
      if (getCircularPlane() != PLANE_YZ) {
        linearize(getTolerance());
        return;
      }
    }
  } */

  if (isSpeedFeedSynchronizationActive()) {
    error(localize("Speed-feed synchronization is not supported for circular moves."));
    return;
  }

  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for a circular move."));
    return;
  }

  var start = getCurrentPosition();

  if (isFullCircle()) {
    if (properties.useRadius || isHelical() || machineState.usePolarMode) { // radius mode does not support full arcs
      linearize(tolerance);
      return;
    }
    switch (getCircularPlane()) {
    case PLANE_XY:
      xOutput.reset();
      yOutput.reset();
      writeBlock(gPlaneModal.format(getG17Code()), gMotionModal.format(directionCode), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), getFeed(feed));
      break;
    case PLANE_ZX:
       if (machineState.usePolarMode) {
        linearize(tolerance);
        return;
      }
      zOutput.reset();
      xOutput.reset();
      writeBlock(gPlaneModal.format(18), gMotionModal.format(directionCode), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    case PLANE_YZ:
      if (machineState.usePolarMode) {
        linearize(tolerance);
        return;
      }
      yOutput.reset();
      zOutput.reset();
      writeBlock(gPlaneModal.format(19), gMotionModal.format(directionCode), jOutput.format(cy - start.y, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    default:
      linearize(tolerance);
    }
  } else if (!properties.useRadius && !machineState.usePolarMode) {
    if (isHelical() && ((getCircularSweep() < toRad(30)) || (getHelicalPitch() > 10))) { // avoid G112 issue
      linearize(tolerance);
      return;
    }
    switch (getCircularPlane()) {
    case PLANE_XY:
      xOutput.reset();
      yOutput.reset();
      writeBlock(gPlaneModal.format(getG17Code()), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), getFeed(feed));
      break;
    case PLANE_ZX:
      if (machineState.usePolarMode) {
        linearize(tolerance);
        return;
      }
      zOutput.reset();
      xOutput.reset();
      writeBlock(gPlaneModal.format(18), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    case PLANE_YZ:
      if (machineState.usePolarMode) {
        linearize(tolerance);
        return;
      }
      yOutput.reset();
      zOutput.reset();
      writeBlock(gPlaneModal.format(19), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), jOutput.format(cy - start.y, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    default:
      linearize(tolerance);
    }
  } else { // use radius mode
    if (isHelical() && ((getCircularSweep() < toRad(30)) || (getHelicalPitch() > 10) || machineState.usePolarMode)) {
      linearize(tolerance);
      return;
    }
    var r = getCircularRadius();
    if (toDeg(getCircularSweep()) > (180 + 1e-9)) {
      linearize(tolerance);
      return;
    }
    switch (getCircularPlane()) {
    case PLANE_XY:
      xOutput.reset();
      yOutput.reset();
      writeBlock(gPlaneModal.format(getG17Code()), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), "L" + rFormat.format(r), getFeed(feed));
      break;
    case PLANE_ZX:
      if (machineState.usePolarMode) {
        linearize(tolerance);
        return;
      }
      zOutput.reset();
      xOutput.reset();
      writeBlock(gPlaneModal.format(18), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), "L" + rFormat.format(r), getFeed(feed));
      break;
    case PLANE_YZ:
      if (machineState.usePolarMode) {
        linearize(tolerance);
        return;
      }
      yOutput.reset();
      zOutput.reset();
      writeBlock(gPlaneModal.format(19), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), "L" + rFormat.format(r), getFeed(feed));
      break;
    default:
      linearize(tolerance);
    }
  }
}

var wAxisTorqueUpper = 30;
var wAxisTorqueMiddle = 25;
var wAxisTorqueLower = 5;

function onCycle() {
  if ((typeof isSubSpindleCycle == "function") && isSubSpindleCycle(cycleType)) {
    isNewSpindle = true;
    writeln("");
    if (hasParameter("operation-comment")) {
      var comment = getParameter("operation-comment");
      if (comment) {
        writeComment(comment);
      }
    }

    // Start of stock transfer operation(s)
    if (!stockTransferIsActive) {

      if((getNextSection().hasParameter("operation-strategy") && getNextSection().getParameter("operation-strategy") == "turningPart") && (getPreviousSection().hasParameter("operation-strategy") && getPreviousSection().getParameter("operation-strategy") == "turningPart") && (getPreviousSection().hasParameter("operation:goHomeMode") && (getPreviousSection().getParameter("operation:goHomeMode") != "begin end"))) {
        onCommand(COMMAND_OPTIONAL_STOP);
        if (getPreviousSection().getTool().getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
          var initialPosition = getCurrentPosition();
          var spindleDir = mFormat.format(getPreviousSection().getTool().clockwise ? getCode("START_SPINDLE_CW", getSpindle(false)) : getCode("START_SPINDLE_CCW", getSpindle(false)));
          writeBlock(
            gSpindleModeModal.format(getCode("CONSTANT_SURFACE_SPEED_OFF", getSpindle(false))),
            sOutput.format(Math.min((getPreviousSection().getTool().surfaceSpeed)/(Math.PI*initialPosition.x*2), properties.maximumSpindleSpeed))
            // spindleDir
          );
        }
        writeBlock(gFormat.format(270), "(Turning Mode ON)");
      } else {

        writeBlock(gFormat.format(13));
        writeBlock(gFormat.format(140));
        writeRetract();
        onCommand(COMMAND_OPTIONAL_STOP);
        //writeBlock(cAxisEnableModal.format(getCode("DISABLE_C_AXIS", getSpindle(true))));
        writeBlock(gFormat.format(270), "(Turning Mode ON)");
        yOutput.disable();
        writeBlock("T100");
        writeRetract();
        onCommand(COMMAND_STOP_SPINDLE);
      }
      writeBlock("N" + waitNumber + " P" + (waitNumber));
      writeBlock(gFormat.format(14));
      writeBlock(gFormat.format(140));
      onCommand(COMMAND_STOP_SPINDLE);
      writeBlock(gFormat.format(20), "HP=" + spatialFormat.format(3)); // retract
      writeBlock("N" + waitNumber + " P" + (waitNumber));
      waitNumber += 10;
      if ((getNextSection().hasParameter("operation-strategy") && getNextSection().getParameter("operation-strategy") == "turningPart") && (getPreviousSection().hasParameter("operation-strategy") && getPreviousSection().getParameter("operation-strategy") == "turningPart") && (getPreviousSection().hasParameter("operation:goHomeMode") && (getPreviousSection().getParameter("operation:goHomeMode") != "begin end"))) {
        partWasCutOff = true;
      } else {
        writeBlock(mFormat.format(331));
        writeBlock(gFormat.format(145)); //Wait code to allow for Tool Restart on the machine
        writeBlock(gFormat.format(144)); //Wait code to allow for Tool Restart on the machine
      }
      writeBlock("N" + waitNumber + " P" + (waitNumber));
      waitNumber += 10;
      writeBlock(gFormat.format(13));
      gFeedModeModal.reset();
      writeBlock(gFeedModeModal.format(getCode("FEED_MODE_MM_MIN", getSpindle(false))));
      /*
            onCommand(COMMAND_COOLANT_OFF);
            onCommand(COMMAND_OPTIONAL_STOP);
            if (cycle.stopSpindle) {
              writeBlock(mFormat.format(getCode("ENABLE_C_AXIS", getSpindle(true))));
              onCommand(COMMAND_UNLOCK_MULTI_AXIS);
              writeBlock(gMotionModal.format(0), cOutput.format(0));
              onCommand(COMMAND_LOCK_MULTI_AXIS);
              // writeBlock(mFormat.format(getCode("DISABLE_C_AXIS", getSpindle(true)))); // cannot disable C-axis when it's locked
            }
            gFeedModeModal.reset();
            var feedMode;
            if (currentSection.feedMode == FEED_PER_REVOLUTION) {
              feedMode = gFeedModeModal.format(getCode("FEED_MODE_MM_REV", getSpindle(false)));
            } else {
              feedMode = gFeedModeModal.format(getCode("FEED_MODE_MM_MIN", getSpindle(false)));
            }
      */
    }
    
    switch (cycleType) {
    case "secondary-spindle-return":
      var secondaryPull = false;
      var secondaryHome = false;
      // Transfer part to secondary spindle
      if (cycle.unclampMode != "keep-clamped") {
        secondaryPull = true;
        secondaryHome = true;
      } else {
        // pull part only (when offset!=0), Return secondary spindle to home (when offset=0)
        if (hasParameter("operation:feedPlaneHeight_offset")) { // Inventor
          secondaryPull = getParameter("operation:feedPlaneHeight_offset") != 0;
        }
        if (hasParameter("operation:feedPlaneHeightOffset")) { // HSMWorks
          secondaryPull = getParameter("operation:feedPlaneHeightOffset") != 0;
        }
        secondaryHome = !secondaryPull;
      }

      if (false && secondaryPull) {
        writeBlock(mFormat.format(getCode("UNCLAMP_CHUCK", getSpindle(true))), formatComment("UNCLAMP MAIN CHUCK"));
        onDwell(cycle.dwell);
        writeBlock(
          gMotionModal.format(1),
          wOutput.format(cycle.feedPosition),
          getFeed(cycle.feedrate),
          formatComment("BAR PULL")
        );
      }
      if (secondaryHome) {
        if (cycle.unclampMode == "unclamp-secondary") { // simple bar pulling operation
          writeBlock(mFormat.format(getCode("CLAMP_CHUCK", getSpindle(true))), formatComment("CLAMP MAIN CHUCK"));
          onDwell(cycle.dwell);
          writeBlock(mFormat.format(getCode("UNCLAMP_CHUCK", getSecondarySpindle())), formatComment("UNCLAMP SUB CHUCK"));
          onDwell(cycle.dwell);
        } else if (cycle.unclampMode == "unclamp-primary") {
          writeBlock(mFormat.format(getCode("UNCLAMP_CHUCK", getSpindle(true))), formatComment("UNCLAMP MAIN CHUCK"));
          onDwell(cycle.dwell);
        }
        writeBlock(mFormat.format(808));
        writeBlock(gMotionModal.format(1), wOutput.format(cycle.feedPosition), getFeed(cycle.feedrate));
        writeBlock(
          gMotionModal.format(0),
          wOutput.format(properties.homePositionW),
          formatComment("SUB SPINDLE RETURN")
        );
        writeBlock(mFormat.format(150));
        onCommand(COMMAND_STOP_SPINDLE);
        writeBlock(mFormat.format(807));
        writeBlock(mFormat.format(getCode("INTERNAL_INTERLOCK_OFF", getSpindle(true))), formatComment("MAIN CHUCK INTERLOCK RELEASE OFF"));
        writeBlock(mFormat.format(getCode("INTERNAL_INTERLOCK_OFF", getSecondarySpindle())), formatComment("SUB CHUCK INTERLOCK RELEASE OFF"));
      } else {
        writeBlock(mFormat.format(getCode("CLAMP_CHUCK", getSpindle(true))), formatComment("CLAMP MAIN CHUCK"));
        onDwell(cycle.dwell);
        // writeBlock(mFormat.format(getCode("COOLANT_THROUGH_TOOL_OFF", getSecondarySpindle())));
        // mInterferModal.reset();
        // writeBlock(mInterferModal.format(getCode("INTERFERENCE_CHECK_OFF", getSpindle(true))));
      }
      stockTransferIsActive = true;
      break;

    case "secondary-spindle-grab":
      if (currentSection.partCatcher) {
        engagePartCatcher(true);
      }
      writeBlock(mFormat.format(89), mFormat.format(289));
        if ((getNextSection().hasParameter("operation-strategy") && getNextSection().getParameter("operation-strategy") == "turningPart") && (getPreviousSection().hasParameter("operation-strategy") && getPreviousSection().getParameter("operation-strategy") == "turningPart") && (getPreviousSection().hasParameter("operation:goHomeMode") && (getPreviousSection().getParameter("operation:goHomeMode") != "begin end"))) {

        } else {
          writeBlock(gFormat.format(145)); //Wait code to allow for Tool Restart on the machine
        }
      writeBlock(mFormat.format(getCode("INTERNAL_INTERLOCK_ON", getSecondarySpindle())), formatComment("SUB CHUCK INTERLOCK RELEASE ON"));
      writeBlock(mFormat.format(getCode("INTERNAL_INTERLOCK_ON", getSpindle(true))), formatComment("MAIN CHUCK INTERLOCK RELEASE ON"));
      writeBlock(mFormat.format(getCode("UNCLAMP_CHUCK", getSecondarySpindle())), formatComment("UNCLAMP OPPOSITE SPINDLE"));
      onDwell(cycle.dwell);
      gSpindleModeModal.reset();

      if (cycle.stopSpindle) { // no spindle rotation
/*
        writeBlock(mFormat.format(getCode("STOP_MAIN_SPINDLE")));
        writeBlock(mFormat.format(getCode("STOP_SUB_SPINDLE")));
        gMotionModal.reset();
        writeBlock(cAxisEngageModal.format(getCode("ENABLE_C_AXIS")));
        writeBlock(gMotionModal.format(0), "C" + abcFormat.format(cycle.spindleOrientation));
*/
      } else { // spindle rotation
        var transferCodes = getSpindleTransferCodes();
        
        // Write out maximum spindle speed
        if (transferCodes.spindleMode == SPINDLE_CONSTANT_SURFACE_SPEED) {
          var maximumSpindleSpeed = (transferCodes.maximumSpindleSpeed > 0) ? Math.min(transferCodes.maximumSpindleSpeed, properties.maximumSpindleSpeed) : properties.maximumSpindleSpeed;
          writeBlock(gFormat.format(50), sOutput.format(maximumSpindleSpeed));
          sOutput.reset();
        }
        /* not needed, done by machine settings
        // write out spindle speed
        var spindleSpeed;
        var spindleMode;
        if (transferCodes.spindleMode == SPINDLE_CONSTANT_SURFACE_SPEED) {
          spindleSpeed = transferCodes.surfaceSpeed * ((unit == MM) ? 1/1000.0 : 1/12.0);
          spindleMode = getCode("CONSTANT_SURFACE_SPEED_ON", getSpindle(true));
        } else {
          spindleSpeed = cycle.spindleSpeed;
          spindleMode = getCode("CONSTANT_SURFACE_SPEED_OFF", getSpindle(true));
        }
        writeBlock(
          gSpindleModeModal.format(spindleMode),
          sOutput.format(spindleSpeed),
          mFormat.format(transferCodes.direction)
        );
        */
        writeBlock(mFormat.format(getCode("SPINDLE_SYNCHRONIZATION_SPEED", getSpindle(true))), formatComment("SYNCHRONIZED ROTATION ON"));
        // writeBlock(mFormat.format(getCode("IGNORE_SPINDLE_ORIENTATION", getSpindle(true))), formatComment("IGNORE SPINDLE ORIENTATION"));
      }
      // clean out chips
/*
      if (airCleanChuck) {
        writeBlock(mFormat.format(getCode("COOLANT_AIR_ON", SPINDLE_MAIN)), formatComment("CLEAN OUT CHIPS"));
        writeBlock(mFormat.format(getCode("COOLANT_AIR_ON", SPINDLE_SUB)));
        onDwell(5.5);
        writeBlock(mFormat.format(getCode("COOLANT_AIR_OFF", SPINDLE_MAIN)));
        writeBlock(mFormat.format(getCode("COOLANT_AIR_OFF", SPINDLE_SUB)));
      }
*/

      // writeBlock(mInterferModal.format(getCode("INTERFERENCE_CHECK_OFF", getSpindle(true))));
      gMotionModal.reset();
      var upperZ = getParameter("stock-upper-z");
      writeBlock(gMotionModal.format(0), wOutput.format(cycle.feedPosition));
      writeBlock(mFormat.format(88), mFormat.format(288));
      //writeBlock(mFormat.format(151));
      writeBlock(mFormat.format(808));
      if (properties.transferUseTorque) {
        writeBlock(gFormat.format(getCode("TORQUE_LIMIT_ON", getSpindle(true))), "PW=" + integerFormat.format(wAxisTorqueUpper));
        writeBlock(
          gFormat.format(getCode("TORQUE_SKIP_ON", getSpindle(true))),
          wOutput.format(cycle.chuckPosition),
          "D" + zFormat.format(cycle.feedPosition - cycle.chuckPosition),
          "L" + zFormat.format(0.5),
          getFeed(cycle.feedrate),
          "PW=" + integerFormat.format(wAxisTorqueMiddle)
        );
        writeBlock(gFormat.format(getCode("TORQUE_LIMIT_ON", getSpindle(true))), "PW=" + integerFormat.format(wAxisTorqueLower));
        writeBlock(gFormat.format(getCode("TORQUE_LIMIT_OFF", getSpindle(true))));
      } else {
        writeBlock(gMotionModal.format(1), wOutput.format(cycle.chuckPosition), getFeed(cycle.feedrate));
        onDwell(cycle.dwell);
      }
      writeBlock(mFormat.format(331));
      writeBlock(mFormat.format(getCode("CLAMP_CHUCK", getSecondarySpindle())), formatComment("CLAMP SUB SPINDLE"));
      writeBlock(mFormat.format(807));
      onDwell(cycle.dwell);
      stockTransferIsActive = true;
      break;
    }
  }

  if (cycleType == "stock-transfer") {
    warning(localize("Stock transfer is not supported. Required machine specific customization."));
    return;
  } else if (!properties.useCycles && tapping) {
    // setSpindle(false, false);
  }
}

function getCommonCycle(x, y, z, r) {
  forceAny();
  if (machineState.useXZCMode) {
    var currentC = getCClosest(x, y, cOutput.getCurrent());
    // setCAxisDirection(cOutput.getCurrent(), currentC); // causes extra hole to be drilled & manual recommends using a single direction for accuracy
    xOutput.reset();
    zOutput.reset();
    cOutput.reset();
    return [xOutput.format(getModulus(x, y)), cOutput.format(currentC),
      zOutput.format(z),
      conditional(r != 0, (gPlaneModal.getCurrent() == 17 ? "K" : "I") + spatialFormat.format(r))];
  } else if (machineState.axialCenterDrilling) {
    return [xOutput.format(x), yOutput.format(y),
    zOutput.format(z), conditional(r != 0, (gPlaneModal.getCurrent() == 17 ? "K" : "I") + spatialFormat.format(r))];
  } else {
// TAG
    cOutput.reset();
    return [xOutput.format(x), yOutput.format(y),
      zOutput.format(z), cOutput.format(currentWorkPlaneABC.z),
     conditional(r != 0, (gPlaneModal.getCurrent() == 17 ? "K" : "I") + spatialFormat.format(r))];
  }
}

function writeCycleClearance(plane, clearance) {
  var currentPosition = getCurrentPosition();
  if (true) {
    onCycleEnd();
    switch (plane) {
    case 17:
      writeBlock(gMotionModal.format(0), zOutput.format(clearance));
      break;
    case 18:
      writeBlock(gMotionModal.format(0), yOutput.format(clearance));
      break;
    case 19:
      writeBlock(gMotionModal.format(0), xOutput.format(clearance));
      break;
    default:
      error(localize("Unsupported drilling orientation."));
      return;
    }
  }
}

var skipThreading = false;
function onCyclePoint(x, y, z) {
  writeBlock(gPlaneModal.format(17)); // TAG check me
  if (!properties.useCycles || currentSection.isMultiAxis()) {
    expandCyclePoint(x, y, z);
    return;
  }

  var plane = gPlaneModal.getCurrent();
  var localZOutput = zOutput;
/*
  if (isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, 1)) ||
      isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, -1))) {
    plane = 17; // XY plane
    localZOutput = zOutput;
  } else if (Vector.dot(currentSection.workPlane.forward, new Vector(0, 0, 1)) < 1e-7) {
    plane = 19; // YZ plane
    localZOutput = xOutput;
  } else {
    expandCyclePoint(x, y, z);
    return;
  }
*/
  switch (cycleType) {
  case "thread-turning":
    if (skipThreading) { // HSM outputs multiple cycles for multi-start threading
      return;
    }
    var numberOfThreads = 1;
    if ((hasParameter("operation:doMultipleThreads") && (getParameter("operation:doMultipleThreads") != 0))) {
      numberOfThreads = getParameter("operation:numberOfThreads");
    }
    if ((properties.useSimpleThread &&
      !(hasParameter("operation:doMultipleThreads") && (getParameter("operation:doMultipleThreads") != 0)))) {
      gCycleModal.reset();
      zOutput.reset();
      writeBlock(
        gCycleModal.format(33),
        xOutput.format(x-cycle.incrementalX),
        zOutput.format(z),
        iOutput.format(cycle.incrementalX, 0),
        pitchOutput.format(cycle.pitch)
      );
    } else {
      if (isLastCyclePoint()) {
        var threadHeight = getParameter("operation:threadDepth");
        var firstDepthOfCut = threadHeight / getParameter("operation:numberOfStepdowns");
        var cuttingAngle = 0;
        if (hasParameter("operation:infeedAngle")) {
          cuttingAngle = getParameter("operation:infeedAngle");
        }

        var threadInfeedMode = "constant";
        if (hasParameter("operation:infeedMode")) {
          threadInfeedMode = getParameter("operation:infeedMode");
        }
        var selectedInfeed = new Array(33, 73);
        if (threadInfeedMode == "reduced") {
          selectedInfeed[0] = 32;
          selectedInfeed[1] = 73;
        } else if (threadInfeedMode == "constant") {
          selectedInfeed[0] = 32;
          selectedInfeed[1] = 75;
        } else if (threadInfeedMode == "alternate") {
          selectedInfeed[0] = 33;
          selectedInfeed[1] = 73;
        }

        writeBlock(
          gMotionModal.format(71),
          xOutput.format(x),
          zOutput.format(z),
          // "A" + taperFormat.format(Math.atan2(cycle.incrementalX, cycle.incrementalZ * -1)), // taper angle instead of I
          conditional(cuttingAngle != 0, "B" + zFormat.format(cuttingAngle * 2)),
          "D" + xFormat.format(firstDepthOfCut),
          "H" + xFormat.format(threadHeight), // output as diameter
          iOutput.format(cycle.incrementalX, 0),
          conditional((numberOfThreads > 1), "Q" + numberOfThreads),
          feedOutput.format(cycle.pitch),
          mFormat.format(selectedInfeed[0]),
          mFormat.format(selectedInfeed[1])
        );
        skipThreading = (numberOfThreads != 0);
      }
    }
    forceFeed();
    return;
  }
  if(cycleType == "gun-drilling"){
    writtenExpandedCycle = true;
    } else {
    writtenExpandedCycle = false;
    } 
  var lockCode = "";

  var rapto = 0;
  if (isFirstCyclePoint()|| writtenExpandedCycle) { // first cycle point
    if (!machineState.axialCenterDrilling) {
      onCommand(COMMAND_LOCK_MULTI_AXIS);
    }

    rapto = cycle.clearance - cycle.retract;

    var F = (gFeedModeModal.getCurrent() == 99 ? cycle.feedrate/tool.spindleRPM : cycle.feedrate);
    var P = (cycle.dwell == 0) ? 0 : clamp(1, cycle.dwell, 99999999); // in seconds
    
    if (machineState.axialCenterDrilling) {
      xOutput.reset();
      zOutput.reset();
    }
    switch (cycleType) {
    case "drilling":
      writeCycleClearance(plane, cycle.clearance);
      localZOutput.reset();
      writeBlock(
        gCycleModal.format(machineState.axialCenterDrilling ? 74 : 181),
        getCommonCycle(x, y, z, rapto),
        "D" + spatialFormat.format(cycle.depth + cycle.retract - cycle.stock),
        feedOutput.format(F)
      );
      break;
    case "counter-boring":
      writeCycleClearance(plane, cycle.clearance);
      localZOutput.reset();
      writeBlock(
        gCycleModal.format(machineState.axialCenterDrilling ? 74 : 182),
        getCommonCycle(x, y, z, rapto),
        "D" + spatialFormat.format(cycle.depth + cycle.retract - cycle.stock),
        conditional(P > 0, eOutput.format(P)),
        feedOutput.format(F)
      );
      break;
    case "deep-drilling":
      writeCycleClearance(plane, cycle.clearance);
      localZOutput.reset();
      writeBlock(
        gCycleModal.format(machineState.axialCenterDrilling ? 74 : 183),
        getCommonCycle(x, y, z, rapto),
        "D" + spatialFormat.format(cycle.incrementalDepth),
        "L" + spatialFormat.format(cycle.incrementalDepth),
        conditional(P > 0, eOutput.format(P)),
        feedOutput.format(F)
      );
      break;
    case "chip-breaking":
    writeCycleClearance(plane, cycle.clearance);
      localZOutput.reset();
      writeBlock(
        gCycleModal.format(machineState.axialCenterDrilling ? 74 : 183),
        getCommonCycle(x, y, z, rapto),
        "D" + spatialFormat.format(cycle.incrementalDepth),
        conditional(cycle.accumulatedDepth > 0, "L" + spatialFormat.format(cycle.accumulatedDepth)),
        conditional(P > 0, eOutput.format(P)),
        feedOutput.format(F)
      );
      break;
    case "tapping":
    case "right-tapping":
    case "left-tapping":
      reverseTap = tool.type == TOOL_TAP_LEFT_HAND;
      if (machineState.axialCenterDrilling) {
        if (P != 0) {
          expandCyclePoint(x, y, z);
        } else {
          writeCycleClearance(plane, cycle.retract);
          writeBlock(
            gCycleModal.format(reverseTap ? 78 : 77),
            getCommonCycle(x, y, z, 0),
            pitchOutput.format(tool.threadPitch)
          );
          onCommand(COMMAND_START_SPINDLE);
        }
      } else {
        writeCycleClearance(plane, cycle.clearance);
        localZOutput.reset();
        writeBlock(
          gCycleModal.format(184),
          getCommonCycle(x, y, z, rapto),
          "D" + spatialFormat.format(cycle.depth + cycle.retract - cycle.stock),
          conditional(P > 0, eOutput.format(P)),
          pitchOutput.format(tool.threadPitch)
        );
      }
      break;
    case "reaming":
    case "boring":
      writeCycleClearance(plane, cycle.clearance);
      localZOutput.reset();
      writeBlock(
        gCycleModal.format(machineState.axialCenterDrilling ? 74 : 189),
        getCommonCycle(x, y, z, rapto),
        "D" + spatialFormat.format(cycle.depth + cycle.retract - cycle.stock),
        conditional(P > 0, eOutput.format(P)),
        feedOutput.format(F)
      );
      break;
      case "gun-drilling":
      validate(spindleAxis == TOOL_AXIS_Z);
     
       var rapidRetract = true;
       var bottom = cycle.stock - cycle.depth; 
       validate((cycle.stock - cycle.startingDepth) >= bottom, localize("Invalid starting depth."));
     
       var usePositioningSpeed = Math.abs(cycle.positioningSpindleSpeed - tool.spindleRPM) >= 1e-6;
       
       if (!cycle.stopSpindle && usePositioningSpeed) {
         onSpindleSpeed(cycle.positioningSpindleSpeed);
       }
       if (cycle.stopSpindle) {
         onCommand(COMMAND_STOP_SPINDLE); 
       }
       onCommand(COMMAND_UNLOCK_MULTI_AXIS); 
         var expand = new ExpandCycle(x, y, z);
         expand.expandPreliminaryZ(cycle.clearance);
         if (cycle.retract < cycle.clearance) {
           expand.expandRapidZ(cycle.retract); 
         }
         onCommand(COMMAND_LOCK_MULTI_AXIS);
         expand.expandLinearZ(Math.max(cycle.stock - cycle.startingDepth, cycle.bottom), cycle.positioningFeedrate);

         if (cycle.stopSpindle) {
           onCommand(COMMAND_START_SPINDLE);
         }
         if (!cycle.stopSpindle) {
           onSpindleSpeed(tool.spindleRPM);
         }
         if(cycle.breakThroughDistance < 0.1){
          expand.expandLinearZ(cycle.bottom, cycle.feedrate);
         } else {
         expand.expandLinearZ(cycle.bottom+cycle.breakThroughDistance, cycle.feedrate);
         expand.expandLinearZ(cycle.bottom, cycle.positioningFeedrate);
         }

     
         if (cycle.dwell > 0) {
           if (cycle.dwellDepth > 0) {
             expand.expandLinearZ(cycle.bottom + cycle.dwellDepth, cycle.feedrate);
           }
           onDwell(cycle.dwell);
         }
         if (cycle.stopSpindle) {
          onCommand(COMMAND_STOP_SPINDLE); 
        } else {
          if (usePositioningSpeed) {
            onSpindleSpeed(cycle.positioningSpindleSpeed);
          }
        }
         if (!rapidRetract) {
           expand.expandLinearZ(cycle.retract, cycle.positioningFeedrate);
         }
         expand.expandRapidZ(cycle.clearance);
         break;
    default:
      expandCyclePoint(x, y, z);
    }
  } else { // position to subsequent cycle points
    if (cycleExpanded) {
      expandCyclePoint(x, y, z);
    } else {
      var step = 0;
      if (cycleType == "chip-breaking" || cycleType == "deep-drilling") {
        step = cycle.incrementalDepth;
      }
      writeBlock(getCommonCycle(x, y, z, rapto, false), lockCode);
    }
  }
}

function onCycleEnd() {
  if (!cycleExpanded && !stockTransferIsActive) {
    writeBlock(gCycleModal.format(180));
    gMotionModal.reset();
  }
  skipThreading = true;
}

function onPassThrough(text) {
  var commands = String(text).split(";");
  for (text in commands) {
    writeBlock(commands[text]);
  }
}

function onParameter(name, value) {
  var invalid = false;
  switch (name) {
  case "action":
    if (String(value).toUpperCase() == "PARTEJECT") {
      ejectRoutine = true;
    } else if (String(value).toUpperCase() == "USEXZCMODE") {
      forceXZCMode = true;
      forcePolarMode = false;
    } else if (String(value).toUpperCase() == "USEPOLARMODE") {
      forcePolarMode = true;
      forceXZCMode = false;
    } else if (String(value).toUpperCase() == "HSSC-ON") {
      HSSC = true;
    } else if (String(value).toUpperCase() == "HSSC-OFF") {
      HSSC = false;
    } else if (String(value).toUpperCase() == "KORTE RETRACT") {
      if (promptKey2(localize("DisableRetract"), localize("Take care, a part of your program is without safety retracts! Check it carefully!"), "OC") == "C") {
        error(localize("Aborted by user."));
        return;
      }
      korteRetract = true;
    } else if (String(value).toUpperCase() == "KORTE RETRACT UIT") {
      korteRetract = false;
    } else {
      invalid = true;
    }
  }
  if (invalid) {
    error(localize("Invalid action parameter: ") + value);
    return;
  }
}

function parseToggle() {
  var stat = undefined;
  for (i=1; i<arguments.length; i++) {
    if (String(arguments[0]).toUpperCase() == String(arguments[i]).toUpperCase()) {
      if (String(arguments[i]).toUpperCase() == "YES") {
        stat = true;
      } else if (String(arguments[i]).toUpperCase() == "NO") {
        stat = false;
      } else {
        stat = i - 1;
        break;
      }
    }
  }
  return stat;
}

var currentCoolantMode = COOLANT_OFF;
var coolantOff = undefined;

function setCoolant(coolant, turret) {
  var coolantCodes = getCoolantCodes(coolant, turret);
  if (Array.isArray(coolantCodes)) {
    for (var c in coolantCodes) {
      writeBlock(coolantCodes[c]);
    }
    return undefined;
  }
  return coolantCodes;
}

function getCoolantCodes(coolant, turret) {
  if (!coolants) {
    error(localize("Coolants have not been defined."));
  }
  if (!coolantOff) { // use the default coolant off command when an 'off' value is not specified for the previous coolant mode
    coolantOff = coolants.off;
  }

  if (coolant == currentCoolantMode) {
    return undefined; // coolant is already active
  }

  var m;
  if (coolant == COOLANT_OFF) {
    m = coolantOff;
    coolantOff = coolants.off;
  }

  switch (coolant) {
  case COOLANT_FLOOD:
    if (!coolants.flood) {
      break;
    }
    m = (turret == 1) ? coolants.flood.turret1.on : coolants.flood.turret2.on;
    coolantOff = (turret == 1) ? coolants.flood.turret1.off : coolants.flood.turret2.off;
    break;
  case COOLANT_THROUGH_TOOL:
    if (!coolants.throughTool) {
      break;
    }
    m = (turret == 1) ? coolants.throughTool.turret1.on : coolants.throughTool.turret2.on;
    coolantOff = (turret == 1) ? coolants.throughTool.turret1.off : coolants.throughTool.turret2.off;
    break;
  case COOLANT_AIR:
    if (!coolants.air) {
      break;
    }
    m = (turret == 1) ? coolants.air.turret1.on : coolants.air.turret2.on;
    coolantOff = (turret == 1) ? coolants.air.turret1.off : coolants.air.turret2.off;
    break;
  case COOLANT_AIR_THROUGH_TOOL:
    if (!coolants.airThroughTool) {
      break;
    }
    m = (turret == 1) ? coolants.airThroughTool.turret1.on : coolants.airThroughTool.turret2.on;
    coolantOff = (turret == 1) ? coolants.airThroughTool.turret1.off : coolants.airThroughTool.turret2.off;
    break;
  case COOLANT_FLOOD_MIST:
    if (!coolants.floodMist) {
      break;
    }
    m = (turret == 1) ? coolants.floodMist.turret1.on : coolants.floodMist.turret2.on;
    coolantOff = (turret == 1) ? coolants.floodMist.turret1.off : coolants.floodMist.turret2.off;
    break;
  case COOLANT_MIST:
    if (!coolants.mist) {
      break;
    }
    m = (turret == 1) ? coolants.mist.turret1.on : coolants.mist.turret2.on;
    coolantOff = (turret == 1) ? coolants.mist.turret1.off : coolants.mist.turret2.off;
    break;
  case COOLANT_SUCTION:
    if (!coolants.suction) {
      break;
    }
    m = (turret == 1) ? coolants.suction.turret1.on : coolants.suction.turret2.on;
    coolantOff = (turret == 1) ? coolants.suction.turret1.off : coolants.suction.turret2.off;
    break;
  case COOLANT_FLOOD_THROUGH_TOOL:
    if (!coolants.floodThroughTool) {
      break;
    }
    m = (turret == 1) ? coolants.floodThroughTool.turret1.on : coolants.floodThroughTool.turret2.on;
    coolantOff = (turret == 1) ? coolants.floodThroughTool.turret1.off : coolants.floodThroughTool.turret2.off;
    break;
  }
  
  if (!m) {
    onUnsupportedCoolant(coolant);
    m = 9;
  }

  if (m) {
    currentCoolantMode = coolant;
    var multipleCoolantBlocks = new Array(); // create a formatted array to be passed into the outputted line
    if (Array.isArray(m)) {
      for (var i in m) {
        multipleCoolantBlocks.push(mFormat.format(m[i]));
      }
    } else {
      multipleCoolantBlocks.push(mFormat.format(m));
    }
    return multipleCoolantBlocks; // return the single formatted coolant value
  }
  return undefined;
}

/*
function setCoolant_OLD(coolant) {
  if (coolant == currentCoolantMode) {
    return; // coolant is already active
  }

  var m = undefined;
  var m2 = undefined;
  if (coolant == COOLANT_OFF) {
    if (currentCoolantMode == COOLANT_THROUGH_TOOL) {
      m = getCode("COOLANT_THROUGH_TOOL_OFF", getSpindle(true));
      m2 = getCode("COOLANT_OFF", getSpindle(true));
    } else if (currentCoolantMode == COOLANT_AIR) {
      m = getCode("COOLANT_AIR_OFF", getSpindle(true));
    } else if (currentCoolantMode == COOLANT_MIST) {
      m = getCode("COOLANT_MIST_OFF", getSpindle(true));
    } else if (currentCoolantMode == COOLANT_AIR_THROUGH_TOOL) {
      m = getCode("COOLANT_AIR_THROUGH_TOOL_OFF", getSpindle(true));
    } else {
      m = getCode("COOLANT_OFF", getSpindle(true));
    }
    if (m2) {
      writeBlock(mFormat.format(m), mFormat.format(m2));
    } else {
      writeBlock(mFormat.format(m));
    }
    currentCoolantMode = COOLANT_OFF;
    return;
  }

  if ((currentCoolantMode != COOLANT_OFF) && (coolant != currentCoolantMode)) {
    setCoolant(COOLANT_OFF);
  }

  switch (coolant) {
  case COOLANT_FLOOD:
    m = getCode("COOLANT_FLOOD_ON");
    break;
  case COOLANT_THROUGH_TOOL:
    m = getCode("COOLANT_THROUGH_TOOL_ON", getSpindle(true));
    // m2 = getCode("COOLANT_FLOOD_ON");
    break;
  case COOLANT_AIR_THROUGH_TOOL:
    m = getCode("COOLANT_AIR_THROUGH_TOOL_ON", getSpindle(true));
    // m2 = getCode("COOLANT_FLOOD_ON");
    break;
  case COOLANT_AIR:
    m = getCode("COOLANT_AIR_ON", getSpindle(true));
    break;
  case COOLANT_MIST:
    m = getCode("COOLANT_MIST_ON", getSpindle(true));
    break;
  case COOLANT_SUCTION:
    m = getCode("COOLANT_SUCTION_ON", getSpindle(true));
    break;
  default:
    warning(localize("Coolant not supported."));
    if (currentCoolantMode == COOLANT_OFF) {
      return;
    }
    coolant = COOLANT_OFF;
    m = getCode("COOLANT_OFF", getSpindle(true));
  }
  if (m2) {
    writeBlock(mFormat.format(m), mFormat.format(m2));
  } else {
    writeBlock(mFormat.format(m));
  }
  currentCoolantMode = coolant;
}
*/

function onSpindleSpeed(spindleSpeed) {
  onSpindleSpeedForce = true;
  setSpindle(false, false, spindleSpeed);
}


function setSpindle(tappingMode, forceRPMMode, spindleSpeed) {
  var spindleDir;
  var spindleSpeed;
  var spindleMode;
  var constantSpeedCuttingTurret;
  gSpindleModeModal.reset();
  var maximumSpindleSpeed = (tool.maximumSpindleSpeed > 0) ? Math.min(tool.maximumSpindleSpeed, properties.maximumSpindleSpeed) : properties.maximumSpindleSpeed;
  if ((getSpindle(true) == SPINDLE_SUB) && !properties.gotSecondarySpindle) {
    error(localize("Secondary spindle is not available."));
    return;
  }
  
  if (false /*tappingMode*/) {
    spindleDir = mFormat.format(getCode("RIGID_TAPPING", getSpindle(false)));
  } else {
    spindleDir = mFormat.format(tool.clockwise ? getCode("START_SPINDLE_CW", getSpindle(false)) : getCode("START_SPINDLE_CCW", getSpindle(false)));
  }

  if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
    if (getSpindle(false) == SPINDLE_LIVE) {
      error(localize("Constant surface speed not supported with live tool."));
      return;
    }
    spindleSpeed = tool.surfaceSpeed * ((unit == MM) ? 1/1000.0 : 1/12.0);
    if (forceRPMMode) { // RPM mode is forced until move to initial position
      var initialPosition = getFramePosition(currentSection.getInitialPosition());
      if(initialPosition.x <= 0){
        initialPosition.x = 0;
      }
      spindleSpeed = Math.min((spindleSpeed * ((unit == MM) ? 1000.0 : 12.0) / (Math.PI*Math.abs(initialPosition.x*2))), maximumSpindleSpeed);
      spindleMode = gSpindleModeModal.format(getCode("CONSTANT_SURFACE_SPEED_OFF", getSpindle(false)));
    } else {
      spindleMode = gSpindleModeModal.format(getCode("CONSTANT_SURFACE_SPEED_ON", getSpindle(false)));
    }
  } else {

    if(onSpindleSpeedForce == true){
      onSpindleSpeed = false;
    } else if(hasParameter("operation:positioningSpindleSpeed")){
      spindleSpeed = getParameter("operation:positioningSpindleSpeed");
    } else{
      spindleSpeed = tool.spindleRPM;
    }
    spindleMode = getSpindle(false) == SPINDLE_LIVE ? "" : gSpindleModeModal.format(getCode("CONSTANT_SURFACE_SPEED_OFF", getSpindle(false)));
  }
  constantSpeedCuttingTurret = gFormat.format((tool.turret == 2) ? 111 : 110);
  var scode = getSpindle(false) == SPINDLE_LIVE ? sbOutput.format(spindleSpeed) : sOutput.format(spindleSpeed);
  var gearCode;
  if (spindleSpeed < 4000) {
    gearCode =  mFormat.format(241);
  } else {
    gearCode =  mFormat.format(242);
  }
  if (getSpindle(false) != SPINDLE_LIVE) {
    if (lowGear || properties.lowGear) {
      gearCode = mFormat.format(41);
    } else {
      gearCode = mFormat.format(42);
    }
  }
  if (getSpindle(false) == SPINDLE_LIVE) {
    writeBlock(spindleMode, scode, spindleDir, gearCode);
  } else {
    if (gotMultiTurret) {
      writeBlock(spindleMode, scode, spindleDir, constantSpeedCuttingTurret, gearCode);}
      else{
          writeBlock(spindleMode, scode, spindleDir, gearCode);   
      }
  }
  // wait for spindle here if required
}

function onCommand(command) {
  switch (command) {
  case COMMAND_COOLANT_OFF:
    setCoolant(COOLANT_OFF);
    break;
  case COMMAND_COOLANT_ON:
  setCoolant(COOLANT_FLOOD, machineState.currentTurret);
    break;
  case COMMAND_LOCK_MULTI_AXIS:
    var code = cAxisBrakeModal.format(getCode("LOCK_MULTI_AXIS", getSpindle(true)));
    var info = code ? "(LOCK MULTI AXIS)" : "";
    writeBlock(code, info);
    break;
  case COMMAND_UNLOCK_MULTI_AXIS:
    var code = cAxisBrakeModal.format(getCode("UNLOCK_MULTI_AXIS", getSpindle(true)));
    var info = code ? "(UNLOCK MULTI AXIS)" : "";
    writeBlock(code, info);
    break;
  case COMMAND_START_CHIP_TRANSPORT:
    writeBlock(mFormat.format(244));
    break;
  case COMMAND_STOP_CHIP_TRANSPORT:
    writeBlock(mFormat.format(243));
    break;
  case COMMAND_OPEN_DOOR:
    if (gotDoorControl) {
      writeBlock(mFormat.format(91)); // optional
    }
    break;
  case COMMAND_CLOSE_DOOR:
    if (gotDoorControl) {
      writeBlock(mFormat.format(90)); // optional
    }
    break;
  case COMMAND_BREAK_CONTROL:
    writeRetract();
    setCoolant(COOLANT_OFF, machineState.currentTurret);
    if (currentSection.spindle == SPINDLE_PRIMARY) {
      writeBlock(mFormat.format(350));
    } else {
      writeBlock(mFormat.format(355));
    }
    writeRetract();
    break;
  case COMMAND_TOOL_MEASURE:
    break;
  case COMMAND_ACTIVATE_SPEED_FEED_SYNCHRONIZATION:
    break;
  case COMMAND_DEACTIVATE_SPEED_FEED_SYNCHRONIZATION:
    break;
  case COMMAND_STOP:
    writeBlock(mFormat.format(0));
    forceSpindleSpeed = true;
    break;
  case COMMAND_OPTIONAL_STOP:
    writeBlock(mFormat.format(1));
    break;
  case COMMAND_END:
    writeBlock(mFormat.format(2));
    break;
  case COMMAND_STOP_SPINDLE:
    if (machineState.constantSurfaceSpeedIsActive) {
      writeBlock(gSpindleModeModal.format(getCode("CONSTANT_SURFACE_SPEED_OFF")), sOutput.format(100), mFormat.format(getCode("STOP_SPINDLE", activeSpindle)));
    } else {
      writeBlock(mFormat.format(getCode("STOP_SPINDLE", activeSpindle)));
    }
    sOutput.reset();
    sbOutput.reset();
    break;
  case COMMAND_ORIENTATE_SPINDLE:
    if (machineState.isTurningOperation || machineState.axialCenterDrilling) {
      writeBlock(mFormat.format(getCode("ORIENT_SPINDLE", getSpindle(true))));
    } else {
      error(localize("Spindle orientation is not supported for live tooling."));
      return;
    }
    break;
  case COMMAND_START_SPINDLE:
    onCommand(tool.clockwise ? COMMAND_SPINDLE_CLOCKWISE : COMMAND_SPINDLE_COUNTERCLOCKWISE);
    return;
  case COMMAND_SPINDLE_CLOCKWISE:
    writeBlock(mFormat.format(getCode("START_SPINDLE_CW", getSpindle(false))));
    break;
  case COMMAND_SPINDLE_COUNTERCLOCKWISE:
    writeBlock(mFormat.format(getCode("START_SPINDLE_CCW", getSpindle(false))));
    break;
  // case COMMAND_CLAMP: // add support for clamping
  // case COMMAND_UNCLAMP: // add support for clamping
  default:
    onUnsupportedCommand(command);
  }
}

/** Get synchronization/transfer code based on part cutoff spindle direction. */
function getSpindleTransferCodes() {
  var tool = currentSection.getTool();
  var transferCodes = {
    direction:tool.clockwise ? getCode("START_SPINDLE_CW", getSpindle(true)) : getCode("START_SPINDLE_CCW", getSpindle(true)),
    spindleMode:SPINDLE_CONSTANT_SPINDLE_SPEED,
    surfaceSpeed:tool.surfaceSpeed,
    maximumSpindleSpeed:tool.maximumSpindleSpeed
  };
  var numberOfSections = getNumberOfSections();
  for (var i = getNextSection().getId(); i < numberOfSections; ++i) {
    var section = getSection(i);
    if (section.hasParameter("operation-strategy")) {
      if (section.getParameter("operation-strategy") == "turningPart") {
        var tool = section.getTool();
        transferCodes.direction = tool.clockwise ? getCode("START_SPINDLE_CW", getSpindle(true)) : getCode("START_SPINDLE_CCW", getSpindle(true));
        transferCodes.spindleMode = tool.getSpindleMode();
        transferCodes.surfaceSpeed = tool.surfaceSpeed;
        transferCodes.maximumSpindleSpeed = tool.maximumSpindleSpeed;
        break;
      } else if (section.getParameter("operation-strategy") == "turningSecondarySpindleReturn") {
        break;
      }
    } else {
      break;
    }
  }
  return transferCodes;
}

function getG17Code() {
  return machineState.usePolarMode ? 17 : 17;
}

function ejectPart() {
  writeln("");
  if (properties.sequenceNumberToolOnly) {
    writeCommentSeqno(localize("PART EJECT"));
  } else {
    writeComment(localize("PART EJECT"));
  }
  gMotionModal.reset();
  // writeBlock(gMotionModal.format(0), gFormat.format(28), gFormat.format(53), "B" + abcFormat.format(0)); // retract bar feeder
  writeRetract();
  // writeRetract(X);
  // writeRetract(Z);

  writeBlock(mFormat.format(getCode("UNLOCK_MULTI_AXIS", getSpindle(true))));
  if (!properties.optimizeCaxisSelect) {
    cAxisEnableModal.reset();
  }
  writeBlock(
    gFeedModeModal.format(getCode("FEED_MODE_MM_MIN", getSpindle(false))),
    // gFormat.format(53 + currentWorkOffset),
    // gPlaneModal.format(17),
    cAxisEnableModal.format(getCode("DISABLE_C_AXIS", getSpindle(true)))
  );
  // setCoolant(COOLANT_THROUGH_TOOL);
  gSpindleModeModal.reset();
  writeBlock(
    gSpindleModeModal.format(getCode("CONSTANT_SURFACE_SPEED_OFF", getSpindle(true))),
    sOutput.format(50),
    mFormat.format(getCode("START_SPINDLE_CW", getSpindle(true)))
  );
  // writeBlock(mFormat.format(getCode("INTERLOCK_BYPASS", getSpindle(true))));
  // if (properties.gotPartCatcher) {
  //   writeBlock(mFormat.format(getCode("PART_CATCHER_ON", getSpindle(true))));
  // }
  writeBlock(mFormat.format(getCode("UNCLAMP_CHUCK", getSpindle(true))));
  onDwell(1.5);
  // writeBlock(mFormat.format(getCode("CYCLE_PART_EJECTOR")));
  // onDwell(0.5);
  // if (properties.gotPartCatcher) {
  //   writeBlock(mFormat.format(getCode("PART_CATCHER_OFF", getSpindle(true))));
  //   onDwell(1.1);
  // }
  
  // clean out chips
/*
  if (airCleanChuck) {
    writeBlock(mFormat.format(getCode("COOLANT_AIR_ON", getSpindle(true))));
    onDwell(2.5);
    writeBlock(mFormat.format(getCode("COOLANT_AIR_OFF", getSpindle(true))));
  }
*/
  writeBlock(mFormat.format(getCode("STOP_SPINDLE", getSpindle(true))));
  // setCoolant(COOLANT_OFF);
  writeComment(localize("END OF PART EJECT"));
  writeln("");
}

function engagePartCatcher(engage) {
  if (properties.gotPartCatcher) {
    if (engage) { // engage part catcher
      writeBlock(mFormat.format(getCode("PART_CATCHER_ON", true)), formatComment(localize("PART CATCHER ON")));
    } else { // disengage part catcher
      setCoolant(COOLANT_OFF, machineState.currentTurret);
      writeBlock(mFormat.format(getCode("PART_CATCHER_OFF", true)), formatComment(localize("PART CATCHER OFF")));
    }
  }
}

function onSectionEnd() {
  if (machineState.usePolarMode) {
    setPolarMode(false); // disable polar interpolation mode
  }
  


  if (currentSection.isMultiAxis()) {
    forceXYZ();
    var abc = getCurrentDirection();
    var xyz = getCurrentPosition();

    forceABC();
    // read machines current XYZ positions, TCP OFF command would move xyz otherwise
    writeBlock("NOEX RX1=VSIOX");
    writeBlock("NOEX RY1=VSIOY");
    writeBlock("NOEX RZ1=VSIOZ");
    writeBlock(gFormat.format(254), "X=RX1 Y=RY1 Z=RZ1", bOutput.format(abc.y), cOutput.format(abc.z));
    writeBlock(gFormat.format(0), "X" + xFormat.format(1500)); // retract
    writeBlock(gFormat.format(0), "Z" + xFormat.format(655)); // retract
    writeBlock(gFormat.format(0), bOutput.format(0));
    writeBlock(mFormat.format(404)); // lock B-axis
    writeBlock(gFormat.format(148) + " (B-AXIS MODE OFF)");
    writeBlock(mFormat.format(331));
    writeBlock(gFormat.format(98)); // turn on collision monitor
  }

  // if (properties.gotPartCatcher && partCutoff && currentSection.partCatcher) {
  //   engagePartCatcher(false);
  // }
/*
  // Handled in start of onSection
  if (!isLastSection()) {
    if ((getLiveToolingMode(getNextSection()) < 0) && !currentSection.isPatterned() && (getLiveToolingMode(currentSection) >= 0)) {
      writeBlock(cAxisEngageModal.format(getCode("DISABLE_C_AXIS", getSpindle(true))));
    }
  }
*/

  var forceToolAndRetract = optionalSection && !getNextSection.isOptional();

  if (hasNextSection()) {
    var useG97 = (forceToolAndRetract || isFirstSection() ||
      currentSection.getForceToolChange && currentSection.getForceToolChange() ||
      (tool.number != getNextSection().getTool().number) ||
      (tool.compensationOffset != getNextSection().getTool().compensationOffset) ||
      (tool.diameterOffset != getNextSection().getTool().diameterOffset) ||
      (tool.lengthOffset != getNextSection().getTool().lengthOffset) || (getNextSection().hasParameter("operation-strategy") && getNextSection().getParameter("operation-strategy") == "turningSecondarySpindleGrab")) && (currentSection.hasParameter("operation-strategy") && currentSection.getParameter("operation-strategy") != "turningSecondarySpindleReturn");
  } else {
    useG97 = true;
  }
  
  if (useG97) {

    // cancel SFM mode to preserve spindle speed
    if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
      var initialPosition = getCurrentPosition();
      if(initialPosition.x <= 0){
        initialPosition.x = 0;
      }
      //var spindleDir = mFormat.format(getPreviousSection().getTool().clockwise ? getCode("START_SPINDLE_CW", getSpindle(false)) : getCode("START_SPINDLE_CCW", getSpindle(false)));
      var maximumSpindleSpeed = (tool.maximumSpindleSpeed > 0) ? Math.min(tool.maximumSpindleSpeed, properties.maximumSpindleSpeed) : properties.maximumSpindleSpeed;
      writeBlock(gSpindleModeModal.format(getCode("CONSTANT_SURFACE_SPEED_OFF", getSpindle(false))), sOutput.format(Math.min((tool.surfaceSpeed) / (Math.PI * initialPosition.x * 2), maximumSpindleSpeed)));
    }
  }

  if ((((getCurrentSectionId() + 1) >= getNumberOfSections()) ||
      (tool.number != getNextSection().getTool().number)) && tool.breakControl) {
    onCommand(COMMAND_BREAK_CONTROL);
  }

/*
  // Handled in onSection
  if ((currentSection.getType() == TYPE_MILLING) &&
      (!hasNextSection() || (hasNextSection() && (getNextSection().getType() != TYPE_MILLING)))) {
    // exit milling mode
    if (isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, 1))) {
      // +Z
    } else if (isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, -1))) {
      // -Z
    } else {
      onCommand(COMMAND_STOP_SPINDLE);
    }
  }
*/

  if (!stockTransferIsActive) {
   // writeBlock("VLMON[" + (currentSection.getId() + 1) + "]=" + "0");
   //setSpindle(false, true);
  }
  if (HSSC) {
    writeBlock(mFormat.format(694));
  }

  forceXZCMode = false;
  forcePolarMode = false;
  partCutoff = false;
  forceAny();
}

/** Output block to do safe retract and/or move to home position. */
function writeRetract() {
  var useG20 = false;
  if (arguments.length == 0) {
    useG20 = true;
    // error(localize("No axis specified for writeRetract()."));
    // return;
  }
  if (useG20) {
    if (currentSection.spindle == SPINDLE_PRIMARY) {
      writeBlock(gFormat.format(20), "HP=" + spatialFormat.format(1)); // retract
    } else {
      writeBlock(gFormat.format(20), "HP=" + spatialFormat.format(2)); // retract
    }
    retracted = true;
    zOutput.reset();
    return;
  }

  var words = []; // store all retracted axes in an array
  for (var i = 0; i < arguments.length; ++i) {
    let instances = 0; // checks for duplicate retract calls
    for (var j = 0; j < arguments.length; ++j) {
      if (arguments[i] == arguments[j]) {
        ++instances;
      }
    }
    if (instances > 1) { // error if there are multiple retract calls for the same axis
      error(localize("Cannot retract the same axis twice in one line"));
      return;
    }
    switch (arguments[i]) {
    case X:
      xOutput.reset();
      words.push(xOutput.format(properties.homePositionX));
      retracted = true; // specifies that the tool has been retracted to the safe plane
      break;
    case Y:
      yOutput.reset();
      words.push(yOutput.format(properties.homePositionY));
      break;
    case Z:
      zOutput.reset();
      words.push(zOutput.format(properties.homePositionZ));
      retracted = true; // specifies that the tool has been retracted to the safe plane
      break;
    default:
      error(localize("Bad axis specified for writeRetract()."));
      return;
    }
  }
  if (words.length > 0) {
    writeBlock(gMotionModal.format(0), words); // retract
  }
  zOutput.reset();
}

function onClose() {

  var liveTool = getSpindle(false) == SPINDLE_LIVE;
  optionalSection = false;
  if (stockTransferIsActive) {
    writeBlock(mFormat.format(getCode("SPINDLE_SYNCHRONIZATION_OFF", getSpindle(true))), formatComment("SYNCHRONIZED ROTATION OFF"));
  } else {
    onCommand(COMMAND_STOP_SPINDLE);
    setCoolant(COOLANT_OFF, machineState.currentTurret);
  }

  writeln("");

  if (properties.gotChipConveyor) {
    onCommand(COMMAND_STOP_CHIP_TRANSPORT);
  }
  if (machineState.tailstockIsActive) {
    writeBlock(mFormat.format(getCode("TAILSTOCK_OFF", SPINDLE_MAIN)));
  }

  gMotionModal.reset();
  if (properties.gotSecondarySpindle) {
    // writeBlock(gMotionModal.format(0), gFormat.format(28), gFormat.format(53), "B" + abcFormat.format(0)); // retract Sub Spindle if applicable
  }

  if (G127isActive) {
    writeBlock(gFormat.format(126) + " (" + "DISABLE TILTED WORKPLANE" + ")");
    G127isActive = false;
    forceWorkPlane();
  }
  // Move to home position
  writeRetract();
  // writeRetract(X);
  // writeRetract(Z);

  if (liveTool) {
    // writeBlock(gFormat.format(28), "H" + abcFormat.format(0)); // unwind
    cAxisEngageModal.reset();
  }
  writeBlock(gPlaneModal.format(getCode("ENABLE_TURNING"), getSpindle(true)));
  
  // Automatically eject part
  if (ejectRoutine) {
    ejectPart();
  }

  if (properties.CASOff) {
    writeBlock(mFormat.format(866));
  }

  if (machineState.yAxisModeIsActive) {
    if (!retracted) {
      error(localize("Cannot disable Y axis mode while the machine is not fully retracted."));
      return;
    }
    writeBlock(gMotionModal.format(0), yOutput.format(0));
    onCommand(COMMAND_UNLOCK_MULTI_AXIS);
    var code = gPolarModal.format(getCode("DISABLE_Y_AXIS", true));
    var info = code ? "(Y AXIS MODE OFF)" : "";
    writeBlock(code, info);
    yOutput.disable();
  }

  writeln("");
  onImpliedCommand(COMMAND_END);
  writeBlock(mFormat.format(215));
  onCommand(COMMAND_OPEN_DOOR);
  writeBlock(mFormat.format(30)); // stop program, spindle stop, coolant off
}
