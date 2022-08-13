/*
 * @Autor       : RichardZhang
 * @E-mail      : m15015553240@163.com
 * @Design      :
 * @Module      :
 * @Devices     :
 * @Tool        :
 * @Description :
 *
 * @LastEditors : RichardZhang
 * @LastEditTime: 2022-07-28 22:53:48
 */
//------------------------------------------------------------------------------
// Candy Taster C-Model
//------------------------------------------------------------------------------

#include "svdpi.h"

// same enums as defined in jelly_bean_pkg.sv

enum flavor_e
{
  NO_FLAVOR,
  APPLE,
  BLUEBERRY,
  BUBBLE_GUM,
  CHOCOLATE
};
enum taste_e
{
  UNKNOWN,
  YUMMY,
  YUCKY
};

extern "C" int check_taste_in_c(flavor_e flavor, svBit sour, taste_e taste)
{
  if (flavor == CHOCOLATE && sour == 1 && taste == YUMMY ||
      !(flavor == CHOCOLATE && sour == 1) && taste == YUCKY)
    return 1; // error
  else
    return 0; // OK
}

//==============================================================================
// Copyright (c) 2014, 2015 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================