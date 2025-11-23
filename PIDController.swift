import Foundation
import SpriteKit

/// Basic PID controller implementation. Uses `Double` internally for all
/// calculations to avoid floating-point shenanigans, but inputs and outputs
/// `CGFloat`s for use with SceneKit and SpriteKit.
class PIDController {
  var kProportion: Double;
  var kIntegral: Double;
  var kDerivative: Double;

  var cProportion: Double = 0;
  var cIntegral: Double = 0;
  var cDerivative: Double = 0;

  var lastError: Double = 0;
  var lastTime: Optional<TimeInterval> = .none;

  init(kP: CGFloat, kI: CGFloat, kD: CGFloat) {
    self.kProportion = Double(kP);
    self.kIntegral = Double(kI);
    self.kDerivative = Double(kD);
  }

  func step(error: CGFloat, deltaTime: TimeInterval) -> CGFloat {
    let time = deltaTime + (lastTime ?? TimeInterval.zero)

    return step(error: error, currentTime: time)
  }

  func step(error errorFloat: CGFloat, currentTime: TimeInterval) -> CGFloat {
    let error = Double(errorFloat);
    let secondsElapsed = (lastTime ?? currentTime).distance(to: currentTime);
    self.lastTime = currentTime;

    let errorDerivative = error - self.lastError;

    self.lastError = error;

    self.cProportion = error
    self.cIntegral += error * secondsElapsed

    self.cDerivative = 0
    if (secondsElapsed > 0) {
      self.cDerivative = errorDerivative / secondsElapsed
    }

    return CGFloat(
      (self.kProportion * self.cProportion) +
      (self.kIntegral   * self.cIntegral) +
      (self.kDerivative * self.cDerivative)
    )
  }
}

