//
//  AKModalResonanceFilter.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka on 9/14/15.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import Foundation

/** A modal resonance filter used for modal synthesis.

A modal resonance filter used for modal synthesis. Plucked and bell sounds can be created using  passing an impulse through a combination of modal filters.
*/
@objc class AKModalResonanceFilter : AKParameter {

    // MARK: - Properties

    private var mode = UnsafeMutablePointer<sp_mode>.alloc(1)

    private var input = AKParameter()


    /** Resonant frequency of the filter. [Default Value: 500] */
    var frequency: AKParameter = akp(500) {
        didSet {
            frequency.bind(&mode.memory.freq)
            dependencies.append(frequency)
        }
    }

    /** Quality factor of the filter. Roughly equal to Q/frequency. [Default Value: 50] */
    var qualityFactor: AKParameter = akp(50) {
        didSet {
            qualityFactor.bind(&mode.memory.q)
            dependencies.append(qualityFactor)
        }
    }


    // MARK: - Initializers

    /** Instantiates the filter with default values

    - parameter input: Input audio signal. 
    */
    init(input sourceInput: AKParameter)
    {
        super.init()
        input = sourceInput
        setup()
        dependencies = [input]
        bindAll()
    }

    /** Instantiates the filter with all values

    - parameter input: Input audio signal. 
    - parameter frequency: Resonant frequency of the filter. [Default Value: 500]
    - parameter qualityFactor: Quality factor of the filter. Roughly equal to Q/frequency. [Default Value: 50]
    */
    convenience init(
        input         sourceInput: AKParameter,
        frequency     freqInput:   AKParameter,
        qualityFactor qInput:      AKParameter)
    {
        self.init(input: sourceInput)
        frequency     = freqInput
        qualityFactor = qInput

        bindAll()
    }

    // MARK: - Internals

    /** Bind every property to the internal filter */
    internal func bindAll() {
        frequency    .bind(&mode.memory.freq)
        qualityFactor.bind(&mode.memory.q)
        dependencies.append(frequency)
        dependencies.append(qualityFactor)
    }

    /** Internal set up function */
    internal func setup() {
        sp_mode_create(&mode)
        sp_mode_init(AKManager.sharedManager.data, mode)
    }

    /** Computation of the next value */
    override func compute() {
        sp_mode_compute(AKManager.sharedManager.data, mode, &(input.leftOutput), &leftOutput);
        sp_mode_compute(AKManager.sharedManager.data, mode, &(input.rightOutput), &rightOutput);
    }

    /** Release of memory */
    override func teardown() {
        sp_mode_destroy(&mode)
    }
}
