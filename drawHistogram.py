import cv2
import matplotlib.pyplot as plt

def main():
	# Get video capture and display video
	cv2.namedWindow("Display color histogram")
	camera = cv2.VideoCapture(0)
	displayFeed = True
	spaceKey = 1048608
	escKey = 1048603

	if camera.isOpened():
		readStatus, imgFrame = camera.read()
	else:
		readStatus = False

	while displayFeed:
		cv2.imshow("Display color histogram", imgFrame)
		readStatus, imgFrame = camera.read()
		key = cv2.waitKey(20)
					
		if (key == spaceKey):	#Press spacebar to take picture for analysis
			print 'Capturing image...'
			displayFeed = False
			img_blur = cv2.GaussianBlur(imgFrame, (5, 5), 0) 			#Blur image
		 	img_hsv  = cv2.cvtColor(img_blur, cv2.COLOR_BGR2HSV)	#Convert to HSV
		 	draw_hist(img_hsv)										#Show HSV histograms
		 	cv2.destroyAllWindows()
		 	camera.release()
		 	print 'Color analysis complete!'
		elif (key == escKey):	#Press esc to exit
			cv2.destroyAllWindows()
			camera.release()
	

def draw_hist(img):
	fig = plt.figure()
	ax = fig.add_subplot(3,1,1)
	ax.set_title('H')
	hist_hue = cv2.calcHist([img], [0], None, [180], [0,180])
	ax.plot(hist_hue)

	ax = fig.add_subplot(3,1,2)
	ax.set_title('S')
	hist_hue = cv2.calcHist([img], [1], None, [256], [0,255])
	ax.plot(hist_hue)

	ax = fig.add_subplot(3,1,3)
	ax.set_title('V')
	hist_hue = cv2.calcHist([img], [2], None, [256], [0,255])
	ax.plot(hist_hue)

	plt.show()


if __name__ == '__main__':
	main()