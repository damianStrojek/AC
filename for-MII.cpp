#include <opencv2/opencv.hpp>
using namespace cv;
using namespace std;

Mat grayImage;

int threshold_value = 100;
const int max_value = 255;
Mat binarizedImage;

void Threshold(int pos, void* userdata)
{
	threshold(grayImage, binarizedImage, threshold_value, max_value, THRESH_BINARY);
	imshow("Binarization", binarizedImage);

}

int main()
{
	Mat srcImage;
	srcImage = imread("ryba.jpg", 1);

	if (!srcImage.data)
	{
		std::cout << "Blad odczytu obrazu!" << endl;
		return 1;
	}

	namedWindow("Source image");
	moveWindow("Source image", 0, 0);
	imshow("Source image", srcImage);


	//obraz achromatyczny
	cvtColor(srcImage, grayImage, COLOR_BGR2GRAY);
	namedWindow("Gray image");
	moveWindow("Gray image", 300, 0);
	imshow("Gray image", grayImage);
	imwrite("Samples/Gray image.jpg", grayImage);

	//obraz skalowany
	Mat resizedImage(100, 100, srcImage.type());
	resize(srcImage, resizedImage, resizedImage.size());
	namedWindow("Resized image");
	moveWindow("Resized image", 600, 0);
	imshow("Resized image", resizedImage);

	//filtr dolno
	Mat blurImage;
	blur(srcImage, blurImage, Size(5, 5));
	namedWindow("Blur image");
	moveWindow("Blur image", 900, 0);
	imshow("Blur image", blurImage);

	//filtr gorno
	Mat CannyImage;
	Canny(srcImage, CannyImage, 90, 90);
	namedWindow("Canny Edges");
	moveWindow("Canny Edges", 1200, 0);
	imshow("Canny Edges", CannyImage);

	//gorno 2

	Mat LaplacianImage;
	Laplacian(grayImage, LaplacianImage, CV_16S, 3);
	Mat scaledLaplacianImage;
	convertScaleAbs(LaplacianImage, scaledLaplacianImage);
	namedWindow("Laplacian Image");
	moveWindow("Laplacian Image", 0, 300);
	imshow("Laplacian Image", scaledLaplacianImage);

	//2a

	const int histSize = 256;
	const int hist_w = 256;
	const int hist_h = 256;
	float range[2] = { 0, 256 };
	const float* histRange = range;
	Mat histImageGray(Size(hist_w, hist_h), CV_8UC3, Scalar(0, 0, 0));
	Mat histogramGray;
	calcHist(&grayImage, 1, 0, Mat(), histogramGray, 1, &histSize, &histRange);
	normalize(histogramGray, histogramGray, range[0], range[1], NORM_MINMAX);
	for (int i = 0; i < 256; i++)
		line(histImageGray, Point(i, hist_h), Point(i, hist_h - histogramGray.at<float>(i)), Scalar(255, 0, 0), 2);

	namedWindow("Histogram Gray");
	moveWindow("Histogram Gray", 300, 300);
	imshow("Histogram Gray", histImageGray);

	//2b
	Mat equalizedHistImage;
	equalizeHist(grayImage, equalizedHistImage);
	namedWindow("Equalized Histogram");
	moveWindow("Equalized Histogram", 600, 300);
	imshow("Equalized Histogram", equalizedHistImage);

	//2c

	Mat hist2(Size(hist_w, hist_h), CV_8UC3, Scalar(0, 0, 0));
	Mat histogram2;
	calcHist(&equalizedHistImage, 1, 0, Mat(), histogram2, 1, &histSize, &histRange);
	normalize(histogram2, histogram2, range[0], range[1], NORM_MINMAX);
	for (int i = 0; i < 256; i++)
		line(hist2, Point(i, hist_h), Point(i, hist_h - histogram2.at<float>(i)), Scalar(255, 0, 0), 1);

	namedWindow("Histogram Equalized");
	moveWindow("Histogram Equalized", 900, 300);
	imshow("Histogram Equalized", hist2);


	//3a
	Mat brightImage;
	srcImage.copyTo(brightImage);

	for (int i = 0; i < brightImage.rows; i++)
	{
		for (int j = 0; j < brightImage.cols; j++)
		{
			Vec3b pixelColor;
			pixelColor = brightImage.at<Vec3b>(Point(j, i));

			for (int k = 0; k < 3; k++)
			{
				if (pixelColor[k] + 100 > 255)
					pixelColor[k] = 255;
				else
					pixelColor[k] += 100;
				brightImage.at<Vec3b>(Point(j, i)) = pixelColor;
			}

		}
	}

	//4 

	namedWindow("Binarization");
	moveWindow("Binarization", 300, 600);
	createTrackbar("Threshold value", "Binarization", &threshold_value, max_value, Threshold);


	namedWindow("Bright Image");
	moveWindow("Bright Image", 0, 600);
	imshow("Bright Image", brightImage);






	waitKey();

	return(0); // no error
}
