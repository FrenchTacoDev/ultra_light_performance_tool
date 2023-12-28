#include "flutter_window.h"
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include "flutter/generated_plugin_registrant.h"

FlutterWindow::FlutterWindow(const flutter::DartProject& project, const wchar_t* args) : project_(project){
    args_ = ConvertArgsToString(args);
}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  //Create and Invoke the Communication Channel to the flutter app letting it know about arguments if there are any 
  if (args_ == "") return true;
  flutter::MethodChannel channel(flutter_controller_->engine()->messenger(), "nativeCommChannel", &flutter::StandardMethodCodec::GetInstance());
  channel.InvokeMethod(std::string("onArgsFromNative"), std::make_unique<flutter::EncodableValue>(flutter::EncodableValue(args_)));

  return true;
}

void FlutterWindow::OnDestroy() {
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}

//Converts the arguments passed in from the command line that are represented as a wchar_t pointer. 
//Since flutter can only handle std::strings in method communication, conversion is needed.
std::string FlutterWindow::ConvertArgsToString(const wchar_t* args)
{
    std::string result = std::string();

    if (args == nullptr) return result;

    int length = WideCharToMultiByte(CP_UTF8, 0, args, -1, nullptr, 0, nullptr, nullptr);
    char* buffer = new char[length];
    WideCharToMultiByte(CP_UTF8, 0, args, -1, buffer, length, nullptr, nullptr);
    result = std::string(buffer);
    delete[] buffer;
    return result;   
}