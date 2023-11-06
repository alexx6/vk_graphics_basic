#include "simple_compute.h"
#include <random>
#include <chrono>

int main()
{
  constexpr int LENGTH = 1000000;
  constexpr int VULKAN_DEVICE_ID = 0;

  std::shared_ptr<SimpleCompute> app = std::make_unique<SimpleCompute>(LENGTH);
  if (app == nullptr)
  {
    std::cout << "Can't create render of specified type" << std::endl;
    return 1;
  }

  uint8_t ws     = 7;
  uint8_t ws2    = ws / 2;
  float conv_mul = 1.0f / ws;
  std::vector<float> values(LENGTH);
  std::vector<float> cpu_res(LENGTH);
  std::vector<float> gpu_res(LENGTH);

  app->InitVulkan(nullptr, 0, VULKAN_DEVICE_ID);

  float *gpu_sum_result = new float;

  for (int test = 0; test < 10; ++test)
  {
    std::cout << "Test " << test << std::endl;

    for (uint32_t i = 0; i < LENGTH; ++i)
    {
      values[i] = (float)std::rand() / RAND_MAX * 2.0 - 1.0f;
    }

    app->InitPipelines(values.data(), gpu_sum_result);

    auto start = std::chrono::high_resolution_clock::now();
    app->Execute();
    auto stop = std::chrono::high_resolution_clock::now();

    auto GPUTime = std::chrono::duration_cast<std::chrono::microseconds>(stop - start).count();
    std::cout << "GPU result: " << *gpu_sum_result << std::endl;
    std::cout << "GPU time in milliseconds: " << GPUTime / 1000.0f << std::endl;

    start = std::chrono::high_resolution_clock::now();
    for (int32_t i = 0; i < LENGTH; ++i)
    {
      float sum = 0.0f;
      for (uint32_t j = (i - ws2 < 0 ? 0 : i - ws2); j < (i + ws2 + 1 > LENGTH ? LENGTH : i + ws2 + 1); ++j)
      {
        sum += values[j];
      }
      cpu_res[i] = values[i] - sum * conv_mul;
    }

    float sum_res_cpu = 0.0f;
    for (uint32_t i = 0; i < LENGTH; ++i)
      sum_res_cpu += cpu_res[i];

    stop         = std::chrono::high_resolution_clock::now();
    auto CPUTime = std::chrono::duration_cast<std::chrono::microseconds>(stop - start).count();
    std::cout << "CPU result: " << sum_res_cpu << std::endl;
    std::cout << "CPU time in milliseconds: " << CPUTime / 1000.0f << std::endl << std::endl;
  }

  return 0;
}
 