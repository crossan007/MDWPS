﻿<#
 .Synopsis
 Enumerieren der vorhandenen Fenster
#>

<#
 .Synopsis
 Enumerieren der vorhandenen Fenster
#>

$TypeDef = @"

using System;
using System.Text;
using System.Collections.Generic;
using System.Runtime.InteropServices;

namespace Api
{

 public class WinStruct
 {
   public string WinTitle {get; set; }
   public int WinHwnd { get; set; }
 }

 public class ApiDef
 {
   private delegate bool CallBackPtr(int hwnd, int lParam);
   private static CallBackPtr callBackPtr = Callback;
   private static List<WinStruct> _WinStructList = new List<WinStruct>();

    [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool SetForegroundWindow(IntPtr hWnd);

   [DllImport("User32.dll")]
   [return: MarshalAs(UnmanagedType.Bool)]
   private static extern bool EnumWindows(CallBackPtr lpEnumFunc, IntPtr lParam);

    [DllImport("User32.dll")]
   [return: MarshalAs(UnmanagedType.Bool)]
   private static extern bool EnumChildWindows(int hWndParent, CallBackPtr lpEnumFunc, IntPtr lParam);

   [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
   static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);

   private static bool Callback(int hWnd, int lparam)
   {
       StringBuilder sb = new StringBuilder(256);
       int res = GetWindowText((IntPtr)hWnd, sb, 256);
      _WinStructList.Add(new WinStruct { WinHwnd = hWnd, WinTitle = sb.ToString() });
       return true;
   }   

   public static List<WinStruct> GetWindows()
   {
      _WinStructList = new List<WinStruct>();
      EnumWindows(callBackPtr, IntPtr.Zero);
      return _WinStructList;
   }

   public static List<WinStruct> GetChildWindows(int parent)
   {
      _WinStructList = new List<WinStruct>();
      EnumChildWindows(parent, callBackPtr, IntPtr.Zero);
      return _WinStructList;
   }

 }
}
"@

Add-Type -TypeDefinition $TypeDef -Language CSharpVersion3

[Api.Apidef]::GetWindows() |
 Where-Object { $_.WinTitle -like "*jab*" } 

