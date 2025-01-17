""" Test module for testing the examples.
 
"""

from jmodelica.tests import testattr

from jmodelica.examples import *


@testattr(stddist = True)
def test_parameter_estimation_1():
    """
    Test the parameter_estimation_1 example
    """

    parameter_estimation_1.run_demo(False)


@testattr(stddist = True)
def test_vdp():
    """
    Test the vdp example
    """

    vdp.run_demo(False)


@testattr(stddist = True)
def test_vdp_minimum_time():
    """
    Test the vdp_minimum_time example
    """

    vdp_minimum_time.run_demo(False)


@testattr(stddist = True)
def test_quadtank():
    """
    Test the quadtank example
    """

    quadtank.run_demo(False)


@testattr(stddist = True)
def test_cstr():
    """
    Test the cstr example
    """

    cstr.run_demo(False)


@testattr(stddist = True)
def test_pendulum():
    """
    Test the pendulum example
    """

    pendulum.run_demo(False)
