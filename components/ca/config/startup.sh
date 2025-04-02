#! /bin/bash

cfssl genkey -initca /ca/ca-csr-orbit.json | cfssljson -bare ca
