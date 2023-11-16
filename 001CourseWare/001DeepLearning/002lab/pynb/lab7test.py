import os

import numpy as np
import matplotlib.pyplot as plt
# import tensorflow.keras as keras

from keras.models import load_model

from keras.models import model_from_json


def plot_voice(x, y_gender, y_num, index_to_show):
    plt.figure(figsize=(10, 10))
    num_speak = np.where(y_num[index_to_show] == 1)[0]
    gender_spoke = y_gender[index_to_show]
    gender_spoke = 'male' if gender_spoke[0] == 1 else 'female'
    plt.plot(list(range(1, 8000 + 1, 1)), x[index_to_show, :])
    plt.title(f'Number {num_speak} spoken by a {gender_spoke} person')
    # 显示图形
    plt.show()


def load_my_model():
    with open('waveform_gender_model.json', 'r') as json_file:
        loaded_model_json = json_file.read()

    model_gender = model_from_json(loaded_model_json)
    model_gender.load_weights('waveform_gender_model.h5')

    with open('waveform_digit_model.json', 'r') as json_file:
        loaded_model_json = json_file.read()

    model_digit = model_from_json(loaded_model_json)
    model_digit.load_weights('waveform_digit_model.h5')

    return model_gender, model_digit


def predict_result(model_gender, model_digit, realtime_voice):
    input_data = (realtime_voice).reshape(1, -1, 1)

    y_gender = model_gender.predict(input_data)
    y_num = model_digit.predict(input_data)


    indices_gender = np.where(y_gender > 0.8)
    first_gender = indices_gender[0][0] if indices_gender[0].size > 0 else 20
    indices_num = np.where(y_num > 0.8)
    first_num = indices_num[0][0] if indices_num[0].size > 0 else 20

    print("gender result:", y_gender)
    print("num result:", y_num)


    print("gender result:", first_gender)
    print("num result:", first_num)


if __name__ == '__main__':
    x = np.load(f'xtrain.npy')
    #y_gender = np.load(f'ytrain_gender.npy')
    #y_num = np.load(f'ytrain_num.npy')

    # plot_voice(x, y_gender, y_num, 1200)
    # model_gender, model_digit = load_my_model()

    with open('waveform_gender_model.json', 'r') as json_file:
        loaded_model_json = json_file.read()

    model_gender = model_from_json(loaded_model_json)
    model_gender.load_weights('waveform_gender_model.h5')

    with open('waveform_digit_model.json', 'r') as json_file:
        loaded_model_json = json_file.read()

    model_digit = model_from_json(loaded_model_json)
    model_digit.load_weights('waveform_digit_model.h5')

    realtime_voice = x[1, :]
    predict_result(model_gender, model_digit, realtime_voice)
