#! /bin/bash

#
# Installation script for clBLAS.
#
# See CK LICENSE for licensing details.
# See CK COPYRIGHT for copyright details.
#
# Developer(s):
# - Grigori Fursin, 2015;
# - Anton Lokhmotov, 2016.
#

# PACKAGE_DIR
# INSTALL_DIR

cd ${INSTALL_DIR}

############################################################
PF=${PACKAGE_URL}/${PACKAGE_NAME}

echo ""
echo "Downloading package from '${PF}' ..."

rm -f $PF

wget ${PF}
if [ "${?}" != "0" ] ; then
  echo "Error: downloading package failed!"
  exit 1
fi

############################################################
echo ""
echo "Ungzipping archive ..."

rm -f ${PACKAGE_NAME1}
gzip -d ${PACKAGE_NAME}
if [ "${?}" != "0" ] ; then
  echo "Error: ungzipping package failed!"
  exit 1
fi

############################################################
echo ""
echo "Untarring archive ..."

rm -rf ${PACKAGE_SUB_DIR}
tar xvf ${PACKAGE_NAME1}
if [ "${?}" != "0" ] ; then
  echo "Error: untaring package failed!"
  exit 1
fi

############################################################
echo ""
echo "Cleaning ..."

cd ${INSTALL_DIR}
rm -rf obj
mkdir obj
cd obj

############################################################
echo ""
echo "Executing cmake ..."

cmake  -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/install" \
      ../${PACKAGE_SUB_DIR}
if [ "${?}" != "0" ] ; then
  echo "Error: cmake failed!"
  exit 1
fi

############################################################
echo ""
echo "Building package ..."
make -j ${CK_HOST_CPU_NUMBER_OF_PROCESSORS}
if [ "${?}" != "0" ] ; then
  echo "Error: build failed!"
  exit 1
fi

############################################################
echo ""
echo "Installing package ..."

rm -rf install
make install

if [ "${?}" != "0" ] ; then
  echo "Error: installation failed!"
  exit 1
fi

exit 0
