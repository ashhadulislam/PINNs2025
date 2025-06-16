#!/usr/bin/env python
# -*- coding: utf-8 -*-
#*******************************#
#		model fitting v1	#
#		2023-03-15 by Li	#
#*******************************#
import sys
import numpy as np
import differint.differint as df
from copy import deepcopy
import array
from scipy.linalg import pinv
import math

global ori_matrix

def rdnumpy(txtname):
	file = open(txtname)
	header = file.readline()# header
	header_split = header.strip('\n').split('\t')
	columns = len(header_split)  # column
	line = file.readlines()
	lines = len(line)+1  # row

	A = np.zeros((lines, columns), dtype=float)
	A[0:] = header_split[0:columns] #first line
	A_row = 1
	for lin in line:
		list = lin.strip('\n').split('\t')
		A[A_row:] = list[0:columns]
		A_row += 1
	return A

def funcV(t):
	global ori_matrix
	tmp_index=int(t*100)
	if(tmp_index>=ori_matrix.shape[0]):
		tmp_index=ori_matrix.shape[0]-1
	return ori_matrix[tmp_index,2]

def funcSpeed(t):
	global ori_matrix
	tmp_index=int(t*100)
	if(tmp_index>=ori_matrix.shape[0]):
		tmp_index=ori_matrix.shape[0]-1
	return ori_matrix[tmp_index,1]

#ori_matrix[tmp_index,0]→V''
def funcA(t):
	global ori_matrix
	tmp_index=int(t*100)
	if(tmp_index>=ori_matrix.shape[0]):
		tmp_index=ori_matrix.shape[0]-1
	return ori_matrix[tmp_index,0]
#P=V/C+RV'+aV'(alpha)+P0 | P=EV+RV'+aV'(alpha)+P0;
def fit_frac1Vexp2V(input_file, alpha, beta):
	global ori_matrix
	ori_matrix = rdnumpy(input_file)#P、V'、V
	new_matrix = np.ones((ori_matrix.shape[0], ori_matrix.shape[1]+2), dtype=float)#
	new_matrix[:,0]=ori_matrix[:,2]#V→L
	new_matrix[:,1]=ori_matrix[:,1]#V‘ →L/s
	P_array = np.array(( ori_matrix.shape[0]), dtype=float)
	P_array=deepcopy(ori_matrix[:,0])#P
	#use ori_matrix[:,0] save V'' values
	ori_matrix[0,0]=new_matrix[1,1]-new_matrix[0,1]#V''
	ori_matrix[ori_matrix.shape[0]-1,0]=new_matrix[ori_matrix.shape[0]-1,1]-new_matrix[ori_matrix.shape[0]-2,1]#V''
	for tmp_row in range(1, ori_matrix.shape[0]-1):
		ori_matrix[tmp_row,0]=(new_matrix[tmp_row+1,1]-new_matrix[tmp_row-1,1])/2#V''
	#differint GL faster than RL
#	if (order<1):
#		res=df.GL(order, funcV, 0, 149.99, 15000)
#	else:
#		res=df.GL(order-1, funcSpeed, 0, 149.99, 15000)
	res=df.GL(alpha, funcV, 0, 149.99, 15000)
#	if (order<1):
#		res=df.GL(order, funcV, 0, 149.99, 15000)
#	elif (order<2):
#		res=df.GL(order-1, funcSpeed, 0, 149.99, 15000)
#	else:
#		res=df.GL(order-2, funcA, 0, 149.99, 15000)
	for tmp_row in range(0, ori_matrix.shape[0]):
		new_matrix[tmp_row,2]=res[tmp_row]
	new_matrix[:,3]=math.e**math.e**(beta*ori_matrix[:,2])#e^V
	new_matrix[:,3]=np.multiply(new_matrix[:,3],ori_matrix[:,2])
	result=np.dot(np.dot(np.linalg.inv(np.dot(new_matrix.T,new_matrix)),new_matrix.T),P_array)
	return array.array('d', result)
