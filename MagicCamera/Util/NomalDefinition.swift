//
//  NomalDefinition.swift
//  MagicCamera
//
//  Created by SuGuocai on 2017/12/14.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation

#if (arch(i386) || arch(x86_64)) && os(iOS)
let DEVICE_IS_SUMILATE = true
#else
let DEVICE_IS_SUMILATE = false
#endif
