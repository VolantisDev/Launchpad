#include "stdafx.h"
#include "LaunchpadOverlayWindow.h"

_Use_decl_annotations_
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE, LPSTR, int nCmdShow)
{
    LaunchpadOverlayWindow overlay(L"Launchpad Overlay");
    return Win32Application::Run(&overlay, hInstance, nCmdShow);
}
