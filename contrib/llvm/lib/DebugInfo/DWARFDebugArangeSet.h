//===-- DWARFDebugArangeSet.h -----------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_DEBUGINFO_DWARFDEBUGARANGESET_H
#define LLVM_DEBUGINFO_DWARFDEBUGARANGESET_H

#include "llvm/Support/DataExtractor.h"
#include <vector>

namespace llvm {

class raw_ostream;

class DWARFDebugArangeSet {
public:
  struct Header {
    // The total length of the entries for that set, not including the length
    // field itself.
    uint32_t Length;
    // The offset from the beginning of the .debug_info section of the
    // compilation unit entry referenced by the table.
    uint32_t CuOffset;
    // The DWARF version number.
    uint16_t Version;
    // The size in bytes of an address on the target architecture. For segmented
    // addressing, this is the size of the offset portion of the address.
    uint8_t AddrSize;
    // The size in bytes of a segment descriptor on the target architecture.
    // If the target system uses a flat address space, this value is 0.
    uint8_t SegSize;
  };

  struct Descriptor {
    uint64_t Address;
    uint64_t Length;
    uint64_t getEndAddress() const { return Address + Length; }
  };

private:
  typedef std::vector<Descriptor> DescriptorColl;
  typedef DescriptorColl::iterator DescriptorIter;
  typedef DescriptorColl::const_iterator DescriptorConstIter;

  uint32_t Offset;
  Header HeaderData;
  DescriptorColl ArangeDescriptors;

public:
  DWARFDebugArangeSet() { clear(); }
  void clear();
  void compact();
  bool extract(DataExtractor data, uint32_t *offset_ptr);
  void dump(raw_ostream &OS) const;

  uint32_t getCompileUnitDIEOffset() const { return HeaderData.CuOffset; }
  uint32_t getOffsetOfNextEntry() const { return Offset + HeaderData.Length + 4; }
  uint32_t findAddress(uint64_t address) const;
  uint32_t getNumDescriptors() const { return ArangeDescriptors.size(); }
  const struct Header &getHeader() const { return HeaderData; }
  const Descriptor *getDescriptor(uint32_t i) const {
    if (i < ArangeDescriptors.size())
      return &ArangeDescriptors[i];
    return NULL;
  }
};

}

#endif
